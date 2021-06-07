//
//  AnimationFactory.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 04/06/2021.
//

import UIKit

class AnimationManager {
    static let shared = AnimationManager()
    
    private init() { }
    
    func transformWithFade(cell: UITableViewCell,
                           from point: CGPoint,
                           transformDuration: TimeInterval = 0.3,
                           fadeDuration: TimeInterval = 0.1,
                           delay: TimeInterval = 0.0) {
        
        cell.transform = CGAffineTransform(translationX: point.x, y: point.y)
        cell.alpha = 0
        
        UIView.animate(withDuration: fadeDuration,
                       delay: delay/2) {
            cell.alpha = 1
        }
        
        UIView.animate(
            withDuration: transformDuration,
            delay: delay,
            options: [.curveEaseInOut],
            animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
            })
    }
}
