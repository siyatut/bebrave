//
//  EmptyStateCell.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 9/12/2567 BE.
//

import UIKit

class EmptyStateView: UIView{
    
    // MARK: - UI components
    
    private let label = UILabel.styled(text: "Пора что-нибудь сюда добавить", color: AppStyle.Colors.primaryColor, isBold: true, alignment: .center)
    
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
