//
//  PlaceholderViewController.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 25/2/2568 BE.
//

import UIKit

class PlaceholderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppStyle.Colors.backgroundColor
        setupPlaceholderLabel()
    }

    private func setupPlaceholderLabel() {
        let label = UILabel()
        label.text = "Этот экран находится в разработке ⏳"
        label.textAlignment = .center
        label.textColor = AppStyle.Colors.textColor
        label.font = AppStyle.Fonts.regularFont(size: 16)
        label.numberOfLines = 0

        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ])
    }
}
