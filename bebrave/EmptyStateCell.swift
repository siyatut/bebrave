//
//  EmptyStateCell.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 9/12/2567 BE.
//

import UIKit

class EmptyStateCell: UICollectionViewCell {
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = AppStyle.Colors.textColor
        label.font = AppStyle.Fonts.boldFont(size: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Пора что-нибудь добавить"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
