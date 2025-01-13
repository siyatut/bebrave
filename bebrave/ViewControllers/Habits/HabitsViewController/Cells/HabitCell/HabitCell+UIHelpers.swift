//
//  HabitCell+UIHelpers.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 13/1/2568 BE.
//

import UIKit

extension HabitCell {
    
    func createLabel(textColor: UIColor, font: UIFont, alpha: CGFloat = 1.0) -> UILabel {
        let label = UILabel()
        label.textColor = textColor
        label.font = font
        label.alpha = alpha
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func createImageView(imageName: String, tintColor: UIColor, alpha: CGFloat = 1.0) -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        view.tintColor = tintColor
        view.alpha = alpha
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func createSwipeButton(imageName: String, color: UIColor, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: imageName), for: .normal)
        button.tintColor = .white
        button.backgroundColor = color
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
}


