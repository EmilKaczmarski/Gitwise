//
//  DismissButton.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 03/06/2021.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class DismissButton: UIView {
    
    var action = PublishRelay<Void>()
    
    private let button = UIButton()
    private let disposeBag = DisposeBag()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupButton()
    }
    
    private func setupView() {
        addSubview(button)
        button.snp.makeConstraints { make in
            make.top.left.equalTo(10)
            make.bottom.right.equalTo(-10)
            make.size.equalTo(30)
        }
        backgroundColor = .white
        layer.cornerRadius = 25
    }
    
    private func setupButton() {
        button.setBackgroundImage(UIImage(named: "cancel"), for: .normal)
        button.rx.tap.bind(to: action).disposed(by: disposeBag)
    }
}
