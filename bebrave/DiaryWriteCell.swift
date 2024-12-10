//
//  DiaryWriteCell.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 21/5/2567 BE.
//

import UIKit

class DiaryWriteCell: UICollectionViewCell {
    
// MARK: - UI Components
    
    private let writeDiaryLabel: UILabel = {
        let label = UILabel()
        label.text = "Заполнить дневник"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chevron: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Chevron")
        view.tintColor = AppStyle.Colors.secondaryColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
// MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Set up components
    
    private func setupComponents() {
        contentView.addSubview(writeDiaryLabel)
        contentView.addSubview(chevron)
   
        NSLayoutConstraint.activate([
            writeDiaryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            writeDiaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            writeDiaryLabel.trailingAnchor.constraint(greaterThanOrEqualTo: chevron.leadingAnchor, constant: -155),
            chevron.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevron.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -21)
            ])
    }
}



