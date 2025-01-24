//
//  EmptyStateCell.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 9/12/2567 BE.
//

import UIKit

class EmptyStateView: UIView{
    
    // MARK: - UI components
    
    private let label = UILabel()
    
    // MARK: - Init
    
    init(text: String = "Пора что-нибудь сюда добавить") {
        super.init(frame: .zero)
        setupLabel(with: text)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        addSubview(label)
        backgroundColor = AppStyle.Colors.backgroundEmptyStateColor
        layer.cornerRadius = AppStyle.Sizes.cornerRadius
        layer.masksToBounds = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setupLabel(with text: String) {
        label.text = text
        label.textColor = AppStyle.Colors.primaryColor
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
    }
    
    // MARK: - Public API
    
    func updateText(_ text: String) {
        label.text = text
    }
}
