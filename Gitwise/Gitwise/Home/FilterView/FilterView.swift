//
//  FilterView.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 05/06/2021.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class FilterView: UIView {
    
    var viewModel: FilterViewModelProtocol! = FilterViewModel()
    
    private lazy var titleLablel: UILabel = {
        let label = UILabel()
        label.font = .gitwiseFont(type: .bold, customSize: 26)
        label.textColor = .wiseDeepBlue
        label.text = "Setup Filters"
        label.isHidden = true
        return label
    }()
    
    private lazy var cancelButton: GitwiseButton = {
        let button = GitwiseButton()
        button.set(style: .normal)
        button.title = "Cancel"
        return button
    }()
    
    lazy var saveButton: GitwiseButton = {
        let button = GitwiseButton()
        button.set(style: .light)
        button.title = "Save"
        return button
    }()
    
    let saveCancelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.isHidden = true
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let showDrawerTrigger = PublishSubject<Bool>()

    private let disposeBag = DisposeBag()
    var filterViews: [FiltersSegmentedView] = []
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let menuButtonView = UIView()
    
    private(set) lazy var menuButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "menu"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        setupUI()
        addSubviews()
        setupConstraintrs()
        setupRx()
    }
    
    func loadView(with filters: [FilterSectionModel]) {
        filters.enumerated().forEach { index, filter in
            let segmentedView = FiltersSegmentedView()
            
            segmentedView.segmentedControl.rx
                .selectedSegmentIndex
                .bind(to: filter.selectedOption)
                .disposed(by: disposeBag)
            
            segmentedView.title = filter.title
            segmentedView.segmentedControl.insertSegment(withTitle: filter.options.left.title, at: 0, animated: true)
            segmentedView.segmentedControl.insertSegment(withTitle: filter.options.center.title, at: 1, animated: true)
            segmentedView.segmentedControl.insertSegment(withTitle: filter.options.right.title, at: 2, animated: true)
            
            verticalStackView.insertArrangedSubview(segmentedView,
                                                    at: verticalStackView.arrangedSubviews.count - 1)
            segmentedView.segmentedControl.selectedSegmentIndex = 1
            segmentedView.isHidden = true
            
            showDrawerTrigger
                .bind(to: segmentedView.rx.showDrawer)
                .disposed(by: disposeBag)
        }
    }
    
    private func setupUI() {
        layer.cornerRadius = 15
        backgroundColor = .white
        
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero
        layer.shadowRadius = 14
        layer.shadowColor = UIColor.wiseDeepGrey.cgColor
    }
    
    private func setupRx() {
        
        cancelButton
            .tapTrigger
            .map { _ in false }
            .bind(to: showDrawerTrigger)
            .disposed(by: disposeBag)
        
        menuButton.rx
            .tap
            .map { true }
            .bind(to: showDrawerTrigger)
            .disposed(by: disposeBag)
        
        showDrawerTrigger
            .subscribe(onNext: { [weak self] shouldShow in
                shouldShow ? self?.showDrawer() : self?.hideDrawer()
            })
            .disposed(by: disposeBag)
        
        viewModel
            .filterSectionsDriver
            .drive(rx.filters)
            .disposed(by: disposeBag)
        
        saveButton
            .tapTrigger
            .bind(to: viewModel.saveTrigger)
            .disposed(by: disposeBag)
    }
    
    
    private func addSubviews() {
        addSubview(verticalStackView)
        menuButtonView.addSubview(menuButton)
        [menuButtonView, titleLablel].forEach(verticalStackView.addArrangedSubview)
        addBottomButtons()
    }
    
    private func addBottomButtons() {
        verticalStackView.addArrangedSubview(saveCancelStackView)
        [UIView(), cancelButton, saveButton].forEach(saveCancelStackView.addArrangedSubview)
    }
    
    private func setupConstraintrs() {
        
        menuButton.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.left.top.bottom.equalToSuperview()
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.top.left.equalTo(20)
            make.bottom.right.equalTo(-20)
        }
    }
    
    func showDrawer() {
        menuButtonView.isHidden = true
        [saveCancelStackView, titleLablel].forEach { $0.isHidden = false }
        layoutIfNeeded()
    }
    
    func hideDrawer() {
        menuButtonView.isHidden = false
        [saveCancelStackView, titleLablel].forEach { $0.isHidden = true }
        layoutIfNeeded()
    }
}

fileprivate extension Reactive where Base: FilterView {
    var filters: Binder<[FilterSectionModel]> {
        Binder(self.base) { view, filters in
            view.loadView(with: filters)
        }
    }
}
