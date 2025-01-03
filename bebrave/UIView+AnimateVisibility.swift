//
//  UIView+AnimateVisibility.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 3/1/2568 BE.
//

import UIKit

extension UIView {
    func animateVisibility(isVisible: Bool, duration: TimeInterval = 0.8, transformEffect: Bool = false, completion: (() -> Void)? = nil) {
        if isVisible {
            self.alpha = 0
            self.isHidden = false
            
            if transformEffect {
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
            
            UIView.animate(
                withDuration: duration,
                delay: 0,
                usingSpringWithDamping: transformEffect ? 0.9 : 1.0,
                initialSpringVelocity: transformEffect ? 0.3 : 0.0,
                options: [.curveEaseInOut],
                animations: {
                    self.alpha = 1
                    if transformEffect {
                        self.transform = .identity
                    }
                },
                completion: { _ in
                    completion?()
                }
            )
        } else {
            UIView.animate(
                withDuration: duration * 0.8,
                animations: {
                    self.alpha = 0
                },
                completion: { _ in
                    self.isHidden = true
                    if transformEffect {
                        self.transform = .identity
                    }
                    completion?()
                })
        }
    }
}

#warning("Подумать, может быть, вообще добавить emptyStateView to NewHabitVC, чтобы при добавлении первой привычки ещё до закрытия экрана показывать emptyStateView")
