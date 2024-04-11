//
//  HabitsCollectionViewCell.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 10/4/2567 BE.
//

import UIKit

class HabitsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let habitsName: UILabel = {
        let label = UILabel()
        label.text = "Учить английский"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let percentDone: UILabel = {
        let label = UILabel()
        label.text = "12 %"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let starDivider: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "StarDivider")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let habitsCount: UILabel = {
        let label = UILabel()
        label.text = "2 из 3"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let horizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
        let views = [habitsName, starDivider, habitsCount]
        for view in views {
            horizontalStackView.addArrangedSubview(view)
        }
        addSubview(horizontalStackView)
        addSubview(percentDone)
        
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            percentDone.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 5),
            percentDone.leadingAnchor.constraint(equalTo: horizontalStackView.leadingAnchor)
        ])
    }
}
