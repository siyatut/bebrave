//
//  DiaryWriteCell.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 21/5/2567 BE.
//

import UIKit

class DiaryWriteCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let writeDiaryLabel = UILabel.styled(text: "Заполнить дневник")
    
    private let chevron: UIImageView = {
        let view = UIImageView()
        view.image = .chevron
        view.tintColor = AppStyle.Colors.secondaryColor
        view.contentMode = .scaleAspectFit
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
            writeDiaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            writeDiaryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            writeDiaryLabel.trailingAnchor.constraint(lessThanOrEqualTo: chevron.leadingAnchor, constant: -8),
            
            chevron.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -21),
            chevron.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            chevron.widthAnchor.constraint(equalToConstant: 24),
            chevron.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}



