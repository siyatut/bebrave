//
//  EmptyStateCell.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 9/12/2567 BE.
//

import UIKit

class EmptyStateView: UICollectionReusableView {
    
    // MARK: - UI components
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = AppStyle.Colors.primaryColor
        label.font = AppStyle.Fonts.boldFont(size: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Пора что-нибудь сюда добавить"
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        backgroundColor = AppStyle.Colors.backgroundEmptyStateColor
        layer.cornerRadius = AppStyle.Sizes.cornerRadius
        layer.masksToBounds = true
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
