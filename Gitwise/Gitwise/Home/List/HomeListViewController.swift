//
//  HomeListViewController.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 02/06/2021.
//

import UIKit
import XCoordinator
import RxCocoa
import RxSwift
import SnapKit

final class HomeListViewController: GitwiseViewController {

    //MARK: - properties
    var previousDisplayedRow = 0
    var previousOffset = 0
    
    private let disposeBag = DisposeBag()
    private let tableView = UITableView()
    private let filterView = FilterView()
    
    private let triggerDetails = PublishSubject<[RepositoryModel]>()
    
    var animationManager: AnimationManager = .shared
    var viewModel: HomeListViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad.onNext(())
        setupRx()
        setupViews()
        setupConstraints()
    }
}

//MARK: - TableViewMethods

extension HomeListViewController: UITableViewDelegate {

}

//MARK: - UI setup

private extension HomeListViewController {
    func setupRx() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    
        viewModel?
            .repositoryDataDriver
            .drive(tableView.rx.items(cellIdentifier: HomeInfoCell.reusableId,
                                      cellType: HomeInfoCell.self)) { [weak self] (row, item, cell) in
                
                cell.load(with: item)
                cell.customImageView.image = item.repositoryType.defaultImage
                
                self?.viewModel.getImage(for: item, completion: { image in

                    let indexPath = IndexPath(row: row, section: 0)
                    if let image = image,
                       self?.tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false {
                        cell.customImageView.image = image
                    }
                })
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .contentOffset
            .throttle(.milliseconds(300),
                      scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .map { [weak self] in
                let offset = Int($0.y)
                var isScrollingDown = offset > self?.previousOffset ?? 0
                self?.previousOffset = offset
                
                if offset < 50 {
                    isScrollingDown = false
                }
                return isScrollingDown
            }
            .bind(to: filterView.rx.isHidden)
            .disposed(by: disposeBag)
        
        
        tableView.rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel.triggerDetails.onNext(indexPath)
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)

        tableView.rx
            .willDisplayCell
            .subscribe(onNext: { [weak self] cell, indexPath in
                self?.animate(cell: cell, for: indexPath.row)
            })
            .disposed(by: disposeBag)
        
        filterView
            .showDrawerTrigger
            .subscribe(onNext: { [weak self] isDrawerVisible in
                self?.tableView.alpha = isDrawerVisible ? 0.3 : 1
                self?.tableView.isUserInteractionEnabled = !isDrawerVisible
            })
            .disposed(by: disposeBag)
        
        filterView
            .viewModel
            .applyFilters
            .subscribe(onNext: { [weak self] filters in
                self?.viewModel.apply(filters: filters)
                self?.filterView.showDrawerTrigger.onNext(false)
                self?.tableView.scrollToTop()
            })
            .disposed(by: disposeBag)
        
        viewModel
            .loaderDriver
            .drive(rx.loaderTrigger)
            .disposed(by: disposeBag)
        
        viewModel
            .errorDriver
            .drive(onNext: { [weak self] model in
                self?.showPopup(with: model)
            })
            .disposed(by: disposeBag)
    }
    
    func setupViews() {
        view.addSubview(tableView)
        view.addSubview(filterView)
        filterView.isHidden = true
        tableView.register(HomeInfoCell.self)
        tableView.separatorStyle = .none
        tableView.contentInset = .init(top: 150, left: 0, bottom: 0, right: 0)
        
        tableView.rowHeight = UITableView.automaticDimension
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .wiseLightGrey
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        filterView.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
}

private extension HomeListViewController {
    func animate(cell: UITableViewCell, for row: Int) {
        let y: CGFloat = (previousDisplayedRow) <= row ? 70 : -70
        let delay = row < 6 ? Double(row)*0.05 : 0.05
        
        animationManager.transformWithFade(cell: cell,
                                           from: .init(x: 0, y: y),
                                           delay: delay)
        previousDisplayedRow = row
    }
}
