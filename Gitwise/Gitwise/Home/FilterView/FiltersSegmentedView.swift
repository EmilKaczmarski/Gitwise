//
//  FiltersSegmentedView.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 05/06/2021.
//

import UIKit
import RxSwift

final class FiltersSegmentedView: UIView {
    
    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    let segmentedControl = UISegmentedControl()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubviews()
        setupConstraints()
    }
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(segmentedControl)
    }
    
    private func setupConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(10)
            make.bottom.equalTo(segmentedControl.snp.top)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.lessThanOrEqualTo(-10)
        }
    }
}

extension Reactive where Base: FiltersSegmentedView {
    var showDrawer: Binder<Bool> {
        Binder(self.base) { view, isVisible in
            view.isHidden = !isVisible
        }
    }
}
