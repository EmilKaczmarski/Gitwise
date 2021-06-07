//
//  HomeListViewModel.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 02/06/2021.
//

import Foundation
import XCoordinator
import RxSwift
import RxCocoa

protocol HomeListViewModelProtocol {
    var repositoryDataDriver: Driver<[RepositoryModel]> { get }
    var triggerDetails: PublishSubject<IndexPath> { get }
    var viewDidLoad: PublishSubject<Void> { get }
    func apply(filters: [FilterSectionModel])
    var images: [RepositoryType: [String: UIImage]] { get set }
    func getImage(for model: RepositoryModel, completion: @escaping ((UIImage?) -> ()))
    var loaderDriver: Driver<Bool> { get }
    var errorDriver: Driver<AlertModel> { get }
}

final class HomeListViewModel: HomeListViewModelProtocol {
        
    //MARK: - Private properties
    private let router: StrongRouter<HomeRoute>
    private let disposeBag = DisposeBag()
    private var repositoryData: [RepositoryModel] = []
    private let repositoryFilteredData = BehaviorRelay<[RepositoryModel]>(value: [])
    private let interactor: HomeInteractorProtocol
    private let loaderCount = BehaviorRelay<Int>(value: 0)
    private let repositoryTypes: [RepositoryType]
    
    var images: [RepositoryType: [String: UIImage]] = [:]
    
    private var appliedOptions: [FilterOption] = [.none, .none]
    
    var loaderDriver: Driver<Bool> {
        loaderTrigger.asDriver(onErrorDriveWith: .never())
    }
    
    private let errorRelay = PublishRelay<AlertModel>()
    
    var errorDriver: Driver<AlertModel> {
        errorRelay.asDriver(onErrorDriveWith: .never())
    }
    
    private var loaderTrigger: Observable<Bool> {
        loaderCount
            .map { $0 > 0 }
            .distinctUntilChanged()
    }
    
    //MARK: - Protocol properties
    var viewDidLoad = PublishSubject<Void>()
    var triggerDetails = PublishSubject<IndexPath>()
    
    var repositoryDataDriver: Driver<[RepositoryModel]> {
        repositoryFilteredData.asDriver(onErrorDriveWith: .never())
    }
    
    init(router: StrongRouter<HomeRoute>,
         interactor: HomeInteractorProtocol = HomeInteractor(),
         repositoryTypes: [RepositoryType] = [.github, .bitbucket]) {
        self.router = router
        self.interactor = interactor
        self.repositoryTypes = repositoryTypes
        setupView()
    }
    
    private func setupView() {
        repositoryTypes.forEach {
            images[$0] = [:]
        }
        
        viewDidLoad
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                viewModel.setupRx()
                viewModel.fetchData()
            }).disposed(by: disposeBag)
    }
    
    func apply(filters: [FilterSectionModel]) {
        var appliedOptions: [FilterOption] = []
        
        filters.forEach { filter in
            
            if filter.selectedOption.value == 0 {
                appliedOptions += [filter.options.left]
            } else if filter.selectedOption.value == 1 {
                appliedOptions += [filter.options.center]
            } else if filter.selectedOption.value == 2 {
                appliedOptions += [filter.options.right]
            }
        }
        
        repositoryFilteredData.accept(filterData(with: appliedOptions))
    }
    
    private func filterData(with options: [FilterOption]) -> [RepositoryModel] {
        guard options != appliedOptions else { return [] }
        
        var mappedModel: [RepositoryModel] = repositoryData
        appliedOptions = []
        
        options.forEach { option in
            appliedOptions.append(option)
            
            switch option {
                case .ascending:
                    mappedModel = mappedModel.sorted { $0.name < $1.name }
                case .descending:
                    mappedModel = mappedModel.sorted { $0.name > $1.name }
                case .bitbucket:
                    mappedModel = mappedModel.filter { $0.repositoryType == .bitbucket }
                case .github:
                    mappedModel = mappedModel.filter { $0.repositoryType == .github }
                case .none:
                    break
            }
        }
        
        return mappedModel
    }

    func getImage(for model: RepositoryModel, completion: @escaping ((UIImage?) -> ())) {
        
        if let image = images[model.repositoryType]?[model.owner.nickname] {
            completion(image)
            return
        }
        
        guard let url = model.owner.imageURL else {
            completion(nil)
            return
        }
        
        interactor
            .fetchImage(with: url)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                
                switch result {
                    case .success(let image):
                        completion(image)
                        self?.images[model.repositoryType]?[model.owner.nickname] = image
                    case .failure:
                        completion(nil)
                }
            }
            .disposed(by: disposeBag)
    }
}

//MARK: - RX setup

private extension HomeListViewModel {
    func setupRx() {
        triggerDetails
            .withUnretained(self)
            .subscribe(onNext: { viewModel, indexPath in
                guard let data = viewModel.repositoryFilteredData.value[safe: indexPath.row]
                else { return }
                
                let image = viewModel.images[data.repositoryType]?[data.owner.nickname]
                viewModel.router.trigger(.repoDetails(data, image))
            })
            .disposed(by: disposeBag)
    }
    
    func fetchData() {
        repositoryTypes.forEach { repository in
            fetch(repository: repository)
        }
    }
    
    private func fetch(repository: RepositoryType) {
        var request: Single<[RepositoryModel]>
        
        switch repository {
            case .github:
                request = interactor.fetchGithubRepositories()
                
            case .bitbucket:
                request = interactor.fetchBitbucketRepositories()
        }
        
        increaseLoader()
        
        request
            .subscribe(onSuccess: { [weak self] data in
                self?.loadRepositories(with: data)
                self?.decreaseLoader()
            }, onFailure: { [weak self] error in
                self?.decreaseLoader()
                self?.errorRelay.accept(.init(title: "Error while fetching data",
                                              message: "Please check internet connection",
                                              actionTitle: "Ok"))
            })
            .disposed(by: disposeBag)
    }
    
    private func loadRepositories(with data: [RepositoryModel]) {
        repositoryData += data
        repositoryFilteredData.accept(repositoryData)
    }
}

private extension HomeListViewModel {
    func increaseLoader() {
        loaderCount.accept(loaderCount.value + 1)
    }
    
    func decreaseLoader() {
        loaderCount.accept(loaderCount.value - 1)
    }
}
