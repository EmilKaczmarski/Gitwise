//
//  GitwiseButton.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 05/06/2021.
//

import UIKit
import RxSwift
import SnapKit

final class GitwiseButton: UIView {
    
    let tapTrigger = PublishSubject<Void>()
    
    var title: String? {
        get { button.currentTitle }
        set { button.setTitle(newValue, for: .normal) }
    }
    
    private let button = UIButton()
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(button)
        button.snp.makeConstraints { make in
            make.left.top.equalTo(10)
            make.height.equalTo(20)
            make.bottom.right.equalTo(-10)
        }
        button.titleLabel?.font = .gitwiseFont()
        layer.cornerRadius = 5
        
        button.rx
            .tap
            .bind(to: tapTrigger)
            .disposed(by: disposeBag)
    }

    func set(style: ButtonStyle) {
        switch style {
            case .light:
                backgroundColor = .wiseDeepBlue
                button.setTitleColor(.wiseLightBlue, for: .normal)
                
            case .normal:
                backgroundColor = .wiseLightBlue
                button.setTitleColor(.wiseDeepBlue, for: .normal)
        }
    }
}

enum ButtonStyle {
    case normal
    case light
}
