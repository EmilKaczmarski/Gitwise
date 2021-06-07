//
//  HomeDetailsViewModel.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 02/06/2021.
//

import UIKit
import XCoordinator
import RxCocoa
import RxSwift
import RxDataSources

protocol HomeDetailsViewModelProtocol {
    var repositoryDetailsDriver: Driver<[SectionModel<String, HomeDetailsCell>]> { get }
    var repositoryTheme: Theme { get }
    var navigateBack: PublishSubject<Void> { get }
    var backgroundImageDriver: Driver<UIImage?> { get }
    var skeletonDriver: Driver<Bool> { get }
}

enum HomeDetailsSection {
    case userName
    case repoName(String)
    case repoDescription(String)
}

enum HomeDetailsCell {
    case title(String, RepositoryType)
    case standard(String, RepositoryType)
    
    var cellId: String {
        UITableViewCell.reusableId
    }
}

final class HomeDetailsViewModel: HomeDetailsViewModelProtocol {
    
    //MARK: - properties
    private let router: StrongRouter<HomeRoute>
    private let repositoryDetailsRelay = BehaviorRelay<[SectionModel<String, HomeDetailsCell>]>(value: [])
    
    private let disposeBag = DisposeBag()
    private let interactor: HomeDetailsInteractorProtocol
    
    let repositoryTheme: Theme
    let navigateBack = PublishSubject<Void>()
    
    var repositoryDetailsDriver: Driver<[SectionModel<String, HomeDetailsCell>]> {
        repositoryDetailsRelay.asDriver(onErrorDriveWith: .never())
    }
    
    private let backgroundImageRelay = PublishRelay<UIImage?>()
    
    var backgroundImageDriver: Driver<UIImage?> {
        backgroundImageRelay.asDriver(onErrorDriveWith: .never())
    }
    
    var skeletonDriver: Driver<Bool> {
        backgroundImageDriver.map { $0 == nil }
    }
    
    //MARK: - init
    
    init(router: StrongRouter<HomeRoute>,
         model: RepositoryModel,
         sectionTypes: [HomeDetailsSection],
         backgroundImage: UIImage?,
         interactor: HomeDetailsInteractorProtocol = HomeDetailsInteractor()) {
    
        self.repositoryTheme = model.repositoryType
        self.router = router
        self.interactor = interactor
        setupRx()
        backgroundImageRelay.accept(backgroundImage)
        prepareData(with: model, sectionTypes: sectionTypes)
    }
}

//MARK: - setup rx
private extension HomeDetailsViewModel {
    func setupRx() {
        navigateBack
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                viewModel.router.trigger(.back)
            })
            .disposed(by: disposeBag)
    }
}

private extension HomeDetailsViewModel {
    
    func prepareData(with model: RepositoryModel, sectionTypes: [HomeDetailsSection]) {
        loadTableViewSections(with: model, sectionTypes: sectionTypes)
        fetchImage(for: model)
    }
    
    func loadTableViewSections(with model: RepositoryModel, sectionTypes: [HomeDetailsSection]) {
        var sections: [SectionModel<String, HomeDetailsCell>] = []
        
        sectionTypes.forEach { section in
            switch section {
                case .userName:
                    sections += [.init(model: "", items: [.title(model.owner.nickname, model.repositoryType)] )]
                case .repoName(let headerTitle):
                    sections += [.init(model: headerTitle, items: [.standard(model.name, model.repositoryType)] )]
                case .repoDescription(let headerTitle):
                    sections += [.init(model: headerTitle, items: [.standard(model.description ?? "", model.repositoryType)] )]
            }
        }
        repositoryDetailsRelay.accept(sections)
    }
    
    func fetchImage(for model: RepositoryModel) {
        interactor
            .fetchImage(with: model.owner.imageURL)
            .subscribe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] result in
        
                switch result {
                    case .success(let image):
                        self?.backgroundImageRelay.accept(image)
                    case .failure:
                        self?.backgroundImageRelay.accept(model.repositoryType.defaultImage)
                }
            }
            .disposed(by: disposeBag)
    }
}
