//
//  HabitCell+Gestures.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 13/1/2568 BE.
//

import UIKit

extension HabitCell {
    
    // MARK: - Gesture methods
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        contentContainer.addGestureRecognizer(tapGesture)
    }
    
    func setupPanGesture() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.cancelsTouchesInView = true
        panGesture.delegate = self
        contentView.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Handle pan gesture
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        switch gesture.state {
        case .began:
            originalCenter = contentContainer.center
            
        case .changed:
            contentContainer.transform = CGAffineTransform(translationX: translation.x, y: 0)
            
        case .ended:
            if translation.x < -buttonWidth {
                showLeftSwipeAction()
            } else if translation.x > buttonWidth {
                showRightSwipeActions()
            } else {
                resetPosition()
            }
        default:
            break
        }
    }
    
    func showRightSwipeActions() {
        isSwiped = true
        UIView.animate(withDuration: 0.3) {
            self.contentContainer.transform = CGAffineTransform(translationX: self.buttonWidth * 2, y: 0)
            self.leftButtonContainer.isHidden = false
            self.rightButtonContainer.isHidden = true
            self.layoutIfNeeded()
        }
    }
    
    func showLeftSwipeAction() {
        isSwiped = true
        UIView.animate(withDuration: 0.3) {
            self.contentContainer.transform = CGAffineTransform(translationX: -self.buttonWidth * 2, y: 0)
            self.rightButtonContainer.isHidden = false
            self.leftButtonContainer.isHidden = true
            self.layoutIfNeeded()
        }
    }
    
    @objc func resetPosition(animated: Bool = true) {
        isSwiped = false
        let animations = {
            self.contentContainer.transform = .identity
            self.leftButtonContainer.isHidden = true
            self.rightButtonContainer.isHidden = true
        }
        if animated {
            UIView.animate(withDuration: 0.3, animations: animations)
        } else {
            animations()
        }
    }
    
    // MARK: - Handle tap gesture
    
    @objc func handleTap() {
        guard var habit = habit else {
            print("No habit found. Exiting tap handler.")
            return
        }
        
        if currentProgress < habit.frequency {
            habit.markCompleted()
            currentProgress += 1
            UserDefaultsManager.shared.updateHabit(habit)
            configure(with: habit)
        } else {
            print("Habit already completed.")
        }
    }
}
