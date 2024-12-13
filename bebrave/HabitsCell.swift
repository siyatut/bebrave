//
//  HabitsCollectionViewCell.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 10/4/2567 BE.
//

import UIKit

class HabitsCell: UICollectionViewCell {
    
// MARK: - UI Components
    
    private lazy var habitsName = createLabel(textColor: .label, font: AppStyle.Fonts.regularFont(size: 16))
    private lazy var percentDone = createLabel(textColor: .secondaryLabel, font: AppStyle.Fonts.regularFont(size: 16))
    private lazy var habitsCount = createLabel(textColor: .secondaryLabel, font: AppStyle.Fonts.regularFont(size: 16))
    private lazy var starDivider = createImageView(imageName: "StarDivider", tintColor: AppStyle.Colors.secondaryColor)
    private lazy var checkbox = createImageView(imageName: "UncheckedCheckbox", tintColor: AppStyle.Colors.borderColor)

    private let horizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
    
    private func addSubviewsToStackView(_ stackView: UIStackView, views: [UIView]) {
        views.forEach { stackView.addArrangedSubview($0) }
    }

    private func setupComponents() {
        addSubviewsToStackView(horizontalStackView, views: [habitsName, starDivider, habitsCount])

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

// MARK: - Methods to create label and image view

extension HabitsCell {
    
    private func createLabel(textColor: UIColor, font: UIFont) -> UILabel {
        let label = UILabel()
        label.textColor = textColor
        label.font = font
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func createImageView(imageName: String, tintColor: UIColor) -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        view.tintColor = tintColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
