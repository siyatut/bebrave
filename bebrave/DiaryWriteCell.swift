//
//  DiaryWriteCell.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 21/5/2567 BE.
//

import UIKit

class DiaryWriteCell: UICollectionViewCell {
    
    // MARK
    
    private let writeDiaryLabel: UILabel = {
        let label = UILabel()
        label.text = "Заполнить дневник"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chevron: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Chevron")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func setupComponents() {
        addSubview(writeDiaryLabel)
        addSubview(chevron)
        
        NSLayoutConstraint.activate([
            writeDiaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            writeDiaryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            chevron.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
           // chevron.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
            
           
        ])
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
