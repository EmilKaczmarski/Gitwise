//
//  HomeDetailsViewController.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 02/06/2021.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import SkeletonView

final class HomeDetailsViewController: UIViewController {
    
    //MARK: - UI
    private let tableView = UITableView()
    private let topImageView = UIImageView()
    private let exitButton = DismissButton()
    
    private let disposeBag = DisposeBag()
    
    var viewModel: HomeDetailsViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
        setupViews()
        setupConstraints()
    }
    
    //MARK: - data source
    
    var dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, HomeDetailsCell>>(configureCell: { (dataSource, table, indexPath, item) in
        var cell: UITableViewCell?
        cell = table.dequeueReusableCell(withIdentifier: UITableViewCell.reusableId)
        
        cell?.selectionStyle = .none
        cell?.textLabel?.textAlignment = .center
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.lineBreakMode = .byWordWrapping
        
        switch item {
            case .standard(let value, let repoType):
                cell?.textLabel?.text = value
                cell?.textLabel?.textColor = .black
                cell?.textLabel?.textAlignment = .left
                cell?.textLabel?.textColor = repoType.primary
                
            case .title(let value, let repoType):
                cell?.textLabel?.text = value
                cell?.textLabel?.textAlignment = .center
                cell?.textLabel?.font = .gitwiseFont(type: .bold, customSize: 25)
                cell?.textLabel?.textColor = repoType.primary
        }
        
        return cell ?? .init()
    })
    
    func setupDataSource() {
        dataSource.titleForHeaderInSection = { dataSource, index in
            dataSource.sectionModels[index].model
        }
    }
}


//MARK: - TableViewMethods

extension HomeDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let labelView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DetailsHeaderView") as? DetailsHeaderView else { return nil }
        labelView.setupColors(for: viewModel.repositoryTheme)
        labelView.title = dataSource.sectionModels[safe: section]?.model
        return labelView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 0 ? 0 : 30
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = Int(scrollView.contentOffset.y)
        
        if offset < 0 && offset > -100 {
            let scaleSize = 1 + CGFloat(abs(offset))/100
            topImageView.transform = CGAffineTransform(scaleX: scaleSize, y: scaleSize)
        } else if offset < -100 {
            topImageView.transform = CGAffineTransform(scaleX: 2, y: 2)
        } else {
            topImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        
    }
}

//MARK: - UI setup

private extension HomeDetailsViewController {
    
    func setupRx() {
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel
            .repositoryDetailsDriver
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        exitButton
            .action
            .bind(to: viewModel.navigateBack)
            .disposed(by: disposeBag)
        
        viewModel
            .backgroundImageDriver
            .drive(topImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel
            .skeletonDriver
            .drive(onNext: { [weak self] showSkeleton in
                if showSkeleton {
                    self?.topImageView.showAnimatedGradientSkeleton()
                } else {
                    self?.topImageView.hideSkeleton()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setupViews() {
        topImageView.isSkeletonable = true
        topImageView.showAnimatedGradientSkeleton()
        
        tableView.register(UITableViewCell.self)
        tableView.register(DetailsHeaderView.self, forHeaderFooterViewReuseIdentifier: "DetailsHeaderView")
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension
        
        [topImageView,
         tableView,
         exitButton].forEach(view.addSubview)
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(240)
        }
        
        topImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(270)
        }
        
        exitButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalTo(20)
        }
    }
}
