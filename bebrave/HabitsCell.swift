//
//  HabitsCollectionViewCell.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 10/4/2567 BE.
//

import UIKit

class HabitsCell: UICollectionViewCell {
    
// MARK: - UI Components
    
    private let habitsName: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = AppStyle.Fonts.regularFont(size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let percentDone: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = AppStyle.Fonts.regularFont(size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let starDivider: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "StarDivider")
        view.tintColor = AppStyle.Colors.secondaryColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let habitsCount: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = AppStyle.Fonts.regularFont(size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let horizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let checkbox: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "UncheckedCheckbox")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = AppStyle.Colors.borderColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
// MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponents()
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false
        contentView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        print("Cell tapped!")
    }
    
// MARK: - Set up components
    
    private func setupComponents() {
        let views = [habitsName, starDivider, habitsCount]
        for view in views {
            horizontalStackView.addArrangedSubview(view)
        }
        contentView.addSubview(horizontalStackView)
        contentView.addSubview(percentDone)
        contentView.addSubview(checkbox)
    
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            horizontalStackView.trailingAnchor.constraint(lessThanOrEqualTo: checkbox.leadingAnchor, constant: 106),
            
            percentDone.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 4),
            percentDone.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            percentDone.leadingAnchor.constraint(equalTo: horizontalStackView.leadingAnchor),
            percentDone.trailingAnchor.constraint(lessThanOrEqualTo: checkbox.leadingAnchor, constant: 106),
            
            checkbox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -23),
            checkbox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
// MARK: - Configure method
    
    func configure(with habit: Habit) {
        habitsName.text = habit.title
        habitsCount.text = "\(habit.progress.values.reduce(0, +)) из \(habit.frequency)"
        let percentage = Int((Double(habit.progress.values.reduce(0, +)) / Double(habit.frequency)) * 100)
        percentDone.text = "\(percentage)%"
    }
}


