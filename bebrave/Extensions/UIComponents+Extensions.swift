//
//  UILabel+UITextField extensions.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 23/12/2567 BE.
//

import UIKit

// MARK: - UILabel styling

extension UILabel {
    static func styled(text: String,
                       fontSize: CGFloat = 16,
                       color: UIColor = AppStyle.Colors.textColor,
                       isBold: Bool = false,
                       alignment: NSTextAlignment = .left,
                       numberOfLines: Int = 1,
                       isHidden: Bool = false,
                       alpha: CGFloat = 1.0
    ) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = color
        label.font = isBold ?
        AppStyle.Fonts.boldFont(size: fontSize) :
        AppStyle.Fonts.regularFont(size: fontSize)
        label.textAlignment = alignment
        label.numberOfLines = numberOfLines
        label.isHidden = isHidden
        label.alpha = alpha
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

// MARK: - UITextField styling

extension UITextField {
    static func styled(placeholder: String,
                       keyboardType: UIKeyboardType = .numberPad,
                       alignment: NSTextAlignment = .left
    ) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.keyboardType = keyboardType
        textField.textAlignment = alignment
        textField.layer.cornerRadius = AppStyle.Sizes.cornerRadius
        textField.layer.borderWidth = AppStyle.Sizes.borderWidth
        textField.layer.borderColor = AppStyle.Colors.borderColor.cgColor
        textField.layer.masksToBounds = true
        textField.backgroundColor = .systemBackground
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
}

// MARK: - ImageView Styling

extension UIImageView {
    static func styled(imageName: String,
                       alpha: CGFloat = 1.0
    ) -> UIImageView {
        let view = UIImageView()
        let originalImage = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        view.image = originalImage
        view.alpha = alpha
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

// MARK: - UIStackView Extension

extension UIStackView {
    static func createStack(
        arrangedSubviews: [UIView],
        axis: NSLayoutConstraint.Axis = .horizontal,
        spacing: CGFloat = 8,
        alignment: UIStackView.Alignment = .leading,
        distribution: UIStackView.Distribution = .fillProportionally
    ) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}
