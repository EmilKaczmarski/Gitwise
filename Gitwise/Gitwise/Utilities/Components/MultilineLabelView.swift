//
//  MultilineLabelView.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 04/06/2021.
//

import UIKit
import SnapKit

final class MultilineLabelView: UIView {
        
    var font: UIFont? {
        get { label.font }
        set { label.font = newValue }
    }
    
    var textColor: UIColor? {
        get { label.textColor }
        set { label.textColor = newValue }
    }
    
    var text: String? {
        get { label.text }
        set { label.text = newValue }
    }
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.backgroundColor = .clear
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private extension MultilineLabelView {
    func setupView() {
        addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
