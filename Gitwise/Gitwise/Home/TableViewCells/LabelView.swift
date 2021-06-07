//
//  DetailsHeaderView.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 03/06/2021.
//

import UIKit
import SnapKit

final class DetailsHeaderView: UITableViewHeaderFooterView {
    
    var title: String? {
        get { label.text }
        set { label.text = newValue }
    }

    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .gitwiseFont(type: .bold)
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }

    private func setupView() {
        addSubview(label)
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
    }
    
    func setupColors(for theme: Theme) {
        label.textColor = theme.primary
        backgroundColor = theme.secondary
    }
}
