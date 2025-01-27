//
//  Untitled.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 31/12/2567 BE.
//

import UIKit

extension BaseHabitViewController {
    
    func delegateTextFields() {
        [habitTextField, timesPerDayTextField, monthsTextField].forEach { $0.delegate = self }
    }
    
    func createStackView(
        arrangedSubviews: [UIView],
        axis: NSLayoutConstraint.Axis = .horizontal,
        spacing: CGFloat = 8,
        alignment: UIStackView.Alignment = .leading,
        distribution: UIStackView.Distribution = .fillProportionally
    ) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    func setupComponents() {
        setupDaysOfWeekStack()
        setupLabelsAndStacks()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupLabelsAndStacks() {
        timesPerDayStack = createStackView(
            arrangedSubviews: [timesPerDayTextField, timesPerDayLabel]
        )
        monthsStack = createStackView(
            arrangedSubviews: [monthsTextField, monthsLabel]
        )
        
        let labels = [
            promiseLabel,
            habitErrorLabel,
            timesPerDayErrorLabel,
            daysOfWeekErrorLabel,
            monthsErrorLabel
        ]
        
        let stacks = [timesPerDayStack, daysOfWeekStack, monthsStack].compactMap { $0 }
        addSubviews(labels + stacks)
    }
    
    private func setupSubviews() {
        addSubviews([emojiImageView, didSaveNewHabitButton, habitTextField])
    }
    
    private func setupConstraints() {
        // Emoji Image
        NSLayoutConstraint.activate([
            emojiImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            emojiImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emojiImageView.widthAnchor.constraint(equalToConstant: 40),
            emojiImageView.heightAnchor.constraint(equalToConstant: 40),
            // Promise Label
            promiseLabel.topAnchor.constraint(equalTo: emojiImageView.bottomAnchor, constant: 16),
            promiseLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            promiseLabel.trailingAnchor.constraint(
                greaterThanOrEqualTo: view.trailingAnchor,
                constant: -187
            ),
            // Habit Text Field
            habitTextField.topAnchor.constraint(equalTo: promiseLabel.bottomAnchor, constant: 16),
            habitTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            habitTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            habitTextField.heightAnchor.constraint(equalToConstant: 48),
            // Habit Error Label
            habitErrorLabel.topAnchor.constraint(equalTo: habitTextField.bottomAnchor, constant: 4),
            habitErrorLabel.leadingAnchor.constraint(equalTo: habitTextField.leadingAnchor, constant: 16),
            habitErrorLabel.trailingAnchor.constraint(equalTo: habitTextField.trailingAnchor),
            // Times Per Day Stack
            timesPerDayStack.topAnchor.constraint(equalTo: habitErrorLabel.bottomAnchor, constant: 16),
            timesPerDayStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            timesPerDayStack.trailingAnchor.constraint(equalTo: habitTextField.trailingAnchor),
            // Times Per Day Error Label
            timesPerDayErrorLabel.topAnchor.constraint(equalTo: timesPerDayStack.bottomAnchor, constant: 4),
            timesPerDayErrorLabel.leadingAnchor.constraint(equalTo: timesPerDayStack.leadingAnchor, constant: 16),
            timesPerDayErrorLabel.trailingAnchor.constraint(equalTo: timesPerDayStack.trailingAnchor),
            // Days of Week Stack
            daysOfWeekStack.topAnchor.constraint(equalTo: timesPerDayErrorLabel.bottomAnchor, constant: 16),
            daysOfWeekStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            daysOfWeekStack.trailingAnchor.constraint(equalTo: habitTextField.trailingAnchor),
            // Days of Week Error Label
            daysOfWeekErrorLabel.topAnchor.constraint(equalTo: daysOfWeekStack.bottomAnchor, constant: 4),
            daysOfWeekErrorLabel.leadingAnchor.constraint(equalTo: daysOfWeekStack.leadingAnchor, constant: 16),
            daysOfWeekErrorLabel.trailingAnchor.constraint(equalTo: daysOfWeekStack.trailingAnchor),
            // Months Stack
            monthsStack.topAnchor.constraint(equalTo: daysOfWeekErrorLabel.bottomAnchor, constant: 16),
            monthsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            monthsStack.trailingAnchor.constraint(equalTo: habitTextField.trailingAnchor),
            // Months Error Label
            monthsErrorLabel.topAnchor.constraint(equalTo: monthsStack.bottomAnchor, constant: 4),
            monthsErrorLabel.leadingAnchor.constraint(equalTo: monthsStack.leadingAnchor, constant: 16),
            monthsErrorLabel.trailingAnchor.constraint(equalTo: monthsStack.trailingAnchor),
            // Align labels in stacks
            timesPerDayLabel.centerYAnchor.constraint(equalTo: timesPerDayTextField.centerYAnchor),
            monthsLabel.centerYAnchor.constraint(equalTo: monthsTextField.centerYAnchor),
            // Text Field Sizes
            timesPerDayTextField.widthAnchor.constraint(equalToConstant: 57),
            timesPerDayTextField.heightAnchor.constraint(equalToConstant: 48),
            monthsTextField.widthAnchor.constraint(equalToConstant: 57),
            monthsTextField.heightAnchor.constraint(equalToConstant: 48),
            // Save Button
            didSaveNewHabitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -42),
            didSaveNewHabitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            didSaveNewHabitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            didSaveNewHabitButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    func setupDaysOfWeekStack() {
        if daysOfWeekStack.arrangedSubviews.isEmpty {
            daysOfWeekStack.axis = .horizontal
            daysOfWeekStack.distribution = .fillEqually
            daysOfWeekStack.spacing = 4
            daysOfWeekStack.translatesAutoresizingMaskIntoConstraints = false
            let dayTitles = ["пн", "вт", "ср", "чт", "пт", "сб", "вс"]
            
            for day in 0..<7 {
                let dayContainer = UIView()
                dayContainer.layer.cornerRadius = AppStyle.Sizes.cornerRadius
                dayContainer.layer.borderWidth = AppStyle.Sizes.borderWidth
                dayContainer.layer.borderColor = AppStyle.Colors.borderColor.cgColor
                dayContainer.layer.masksToBounds = true
                dayContainer.translatesAutoresizingMaskIntoConstraints = false
                dayContainer.tag = day
                dayContainer.addGestureRecognizer(UITapGestureRecognizer(
                    target: self,
                    action: #selector(checkboxTapped(_:)))
                )
                
                let dayStack = UIStackView()
                dayStack.axis = .vertical
                dayStack.alignment = .center
                dayStack.spacing = 8
                dayStack.translatesAutoresizingMaskIntoConstraints = false
                dayContainer.addSubview(dayStack)
                
                let dayLabel = UILabel()
                dayLabel.text = dayTitles[day]
                dayLabel.font = AppStyle.Fonts.regularFont(size: 16)
                dayLabel.textAlignment = .center
                dayLabel.translatesAutoresizingMaskIntoConstraints = false
                
                let checkboxImageView = UIImageView()
                // checkboxImageView.image = UIImage(named: "UncheckedCheckbox")
                checkboxImageView.image = UIImage(named: selectedDays[day] ? "CheckedCheckbox" : "UncheckedCheckbox")
                checkboxImageView.contentMode = .scaleAspectFit
                checkboxImageView.isUserInteractionEnabled = false
                checkboxImageView.tag = 999
                checkboxImageView.translatesAutoresizingMaskIntoConstraints = false
                
                dayStack.addArrangedSubview(dayLabel)
                dayStack.addArrangedSubview(checkboxImageView)
                
                NSLayoutConstraint.activate([
                    dayStack.centerXAnchor.constraint(equalTo: dayContainer.centerXAnchor),
                    dayStack.centerYAnchor.constraint(equalTo: dayContainer.centerYAnchor),
                    dayContainer.heightAnchor.constraint(equalToConstant: 71),
                    checkboxImageView.widthAnchor.constraint(equalToConstant: 24),
                    checkboxImageView.heightAnchor.constraint(equalToConstant: 24)
                ])
                
                daysOfWeekStack.addArrangedSubview(dayContainer)
            }
        } else {
            for (index, subview) in daysOfWeekStack.arrangedSubviews.enumerated() {
                guard let checkboxImageView = subview.viewWithTag(999) as? UIImageView else { continue }
                checkboxImageView.image = UIImage(
                    named: selectedDays[index] ? "CheckedCheckbox" : "UncheckedCheckbox"
                )
            }
        }
    }
    
    func setupErrorLabelConstraints() {
        habitErrorLabelHeightConstraint = habitErrorLabel.heightAnchor.constraint(
            equalToConstant: 0)
        timesPerDayErrorLabelHeightConstraint = timesPerDayErrorLabel.heightAnchor.constraint(
            equalToConstant: 0)
        daysOfWeekErrorLabelHeightConstraint = daysOfWeekErrorLabel.heightAnchor.constraint(
            equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            habitErrorLabelHeightConstraint,
            timesPerDayErrorLabelHeightConstraint,
            daysOfWeekErrorLabelHeightConstraint
        ])
    }
}
