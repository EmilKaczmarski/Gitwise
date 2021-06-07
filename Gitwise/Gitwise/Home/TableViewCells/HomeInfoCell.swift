//
//  HomeInfoCell.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 02/06/2021.
//

import UIKit
import SnapKit

final class HomeInfoCell: UITableViewCell {
    
    //MARK: - subviews
    
    lazy var customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.makeRounded()
        return imageView
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var titleLabelView: MultilineLabelView = {
        let view = MultilineLabelView()
        view.font = .gitwiseFont(type: .bold, customSize: 22)
        return view
    }()
    
    lazy var descriptionLabelView: MultilineLabelView = {
        let view = MultilineLabelView()
        view.font = .gitwiseFont(customSize: 22)
        return view
    }()
    
    private let mainView = UIView()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
}

//MARK: - setup

extension HomeInfoCell {

    private func setupView() {
        mainView.layer.cornerRadius = 13
        
        mainView.layer.shadowOpacity = 1
        mainView.layer.shadowOffset = .zero
        mainView.layer.shadowRadius = 6
        
        mainView.layer.borderWidth = 2
        
        backgroundColor = .clear
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        contentView.addSubview(mainView)
        [customImageView, verticalStackView].forEach(mainView.addSubview)
        [titleLabelView, descriptionLabelView].forEach(verticalStackView.addArrangedSubview)
        
        customImageView.layer.borderWidth = 0
        customImageView.layer.masksToBounds = false
        customImageView.layer.cornerRadius = 35
        customImageView.clipsToBounds = true
    }
    
    private func setupConstraints() {
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.bottom.right.equalTo(-20)
            make.left.equalTo(customImageView.snp.right).offset(20)
        }
        
        customImageView.snp.makeConstraints { make in
            make.left.top.equalTo(20)
            make.size.equalTo(70)
            make.bottom.lessThanOrEqualTo(-20)
        }
        
        mainView.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.bottom.equalTo(-15)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        titleLabelView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        descriptionLabelView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setupColors(for theme: Theme) {
        [titleLabelView, descriptionLabelView].forEach { $0.textColor = theme.primary }
        mainView.backgroundColor = theme.tertiary
        mainView.layer.shadowColor = theme.primary.cgColor
        mainView.layer.borderColor = theme.primary.cgColor
    }
}

//MARK: - loading with data

extension HomeInfoCell {
    func load(with data: RepositoryModel) {
        titleLabelView.text = data.owner.nickname
        descriptionLabelView.text = data.name
        setupColors(for: data.repositoryType)
    }
}
