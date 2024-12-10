//
//  HabitsCollectionViewCell.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 10/4/2567 BE.
//

import UIKit

#warning("Возможно, распознавание жестов не работает из-за конфликтов с Collection View и Navigation Controller")

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
        label.font = AppStyle.Fonts.boldFont(size: 16)
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
    
    private let checkbox: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "UncheckedCheckbox")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = AppStyle.Colors.borderColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    // MARK: - Properties
    
    private var habit: Habit?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponents()
        setupGesture()
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
        contentView.addSubview(horizontalStackView)
        contentView.addSubview(percentDone)
        contentView.addSubview(checkbox)
        
        checkbox.backgroundColor = .red
        contentView.gestureRecognizers?.forEach { print($0) }
        
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
    
    // MARK: - Setup gesture
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(checkboxTapped))
        checkbox.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Configure method
    
    func configure(with habit: Habit) {
        self.habit = habit
        
        habitsName.text = habit.title
        
        let currentProgress = min(habit.progress.values.reduce(0, +), habit.frequency)
        let targetProgress = max(habit.frequency, 1)
        
        habitsCount.text = "\(currentProgress) из \(targetProgress)"
        
        let percentage = Int((Double(currentProgress) / Double(targetProgress)) * 100)
        percentDone.text = "\(percentage)%"
        
        // Обновляем чекбокс
        if currentProgress >= targetProgress {
            checkbox.image = UIImage(named: "CheckedCheckbox")?.withRenderingMode(.alwaysTemplate)
            checkbox.tintColor = .systemGreen
            updateBackgroundColor(with: percentage)
        } else {
            checkbox.image = UIImage(named: "UncheckedCheckbox")?.withRenderingMode(.alwaysTemplate)
            checkbox.tintColor = AppStyle.Colors.borderColor
        }
    }
    
    // MARK: - Update background color
    
    private func updateBackgroundColor(with percentage: Int) {
        let alpha = max(0.1, CGFloat(percentage) / 100.0) // Минимум 10% прозрачности
        let progressColor = UIColor.systemBlue.withAlphaComponent(alpha)
        contentView.backgroundColor = progressColor
    }
    
    // MARK: - Checkbox action
    
    @objc private func checkboxTapped() {
        guard let habit = habit else { return }
        
        var currentProgress = habit.progress.values.reduce(0, +)
        let targetProgress = habit.frequency
        
        if currentProgress < targetProgress {
            currentProgress += 1
            
            var updatedHabit = habit
            updatedHabit.progress[Date()] = currentProgress
            UserDefaultsManager.shared.updateHabit(updatedHabit)
            
            DispatchQueue.main.async {
                self.configure(with: updatedHabit)
            }
        }
    }
}
