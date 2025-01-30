//
//  Untitled.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 31/12/2567 BE.
//

import UIKit

extension BaseHabitViewController {

    // MARK: - Public methods

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

    // MARK: - Setup UI

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

    // MARK: - Constraints setup

    private func setupConstraints() {
        setupEmojiImageConstraints()
        setupPromiseLabelConstraints()
        setupHabitConstraints()
        setupTimesPerDayConstraints()
        setupDaysOfWeekConstraints()
        setupMonthsConstraints()
        setupSaveButtonConstraints()
    }

    private func setupEmojiImageConstraints() {
        NSLayoutConstraint.activate([
            emojiImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            emojiImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emojiImageView.widthAnchor.constraint(equalToConstant: 40),
            emojiImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupPromiseLabelConstraints() {
        NSLayoutConstraint.activate([
            promiseLabel.topAnchor.constraint(equalTo: emojiImageView.bottomAnchor, constant: 16),
            promiseLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            promiseLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -187)
        ])
    }

    private func setupHabitConstraints() {
        NSLayoutConstraint.activate([
            habitTextField.topAnchor.constraint(equalTo: promiseLabel.bottomAnchor, constant: 16),
            habitTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            habitTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            habitTextField.heightAnchor.constraint(equalToConstant: 48),

            habitErrorLabel.topAnchor.constraint(equalTo: habitTextField.bottomAnchor, constant: 4),
            habitErrorLabel.leadingAnchor.constraint(equalTo: habitTextField.leadingAnchor, constant: 16),
            habitErrorLabel.trailingAnchor.constraint(equalTo: habitTextField.trailingAnchor)
        ])
    }

    private func setupTimesPerDayConstraints() {
        NSLayoutConstraint.activate([
            timesPerDayStack.topAnchor.constraint(equalTo: habitErrorLabel.bottomAnchor, constant: 16),
            timesPerDayStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            timesPerDayStack.trailingAnchor.constraint(equalTo: habitTextField.trailingAnchor),

            timesPerDayErrorLabel.topAnchor.constraint(equalTo: timesPerDayStack.bottomAnchor, constant: 4),
            timesPerDayErrorLabel.leadingAnchor.constraint(equalTo: timesPerDayStack.leadingAnchor, constant: 16),
            timesPerDayErrorLabel.trailingAnchor.constraint(equalTo: timesPerDayStack.trailingAnchor),

            timesPerDayLabel.centerYAnchor.constraint(equalTo: timesPerDayTextField.centerYAnchor),
            timesPerDayTextField.widthAnchor.constraint(equalToConstant: 57),
            timesPerDayTextField.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    private func setupDaysOfWeekConstraints() {
        NSLayoutConstraint.activate([
            daysOfWeekStack.topAnchor.constraint(equalTo: timesPerDayErrorLabel.bottomAnchor, constant: 16),
            daysOfWeekStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            daysOfWeekStack.trailingAnchor.constraint(equalTo: habitTextField.trailingAnchor),

            daysOfWeekErrorLabel.topAnchor.constraint(equalTo: daysOfWeekStack.bottomAnchor, constant: 4),
            daysOfWeekErrorLabel.leadingAnchor.constraint(equalTo: daysOfWeekStack.leadingAnchor, constant: 16),
            daysOfWeekErrorLabel.trailingAnchor.constraint(equalTo: daysOfWeekStack.trailingAnchor)
        ])
    }

    private func setupMonthsConstraints() {
        NSLayoutConstraint.activate([
            monthsStack.topAnchor.constraint(equalTo: daysOfWeekErrorLabel.bottomAnchor, constant: 16),
            monthsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            monthsStack.trailingAnchor.constraint(equalTo: habitTextField.trailingAnchor),

            monthsErrorLabel.topAnchor.constraint(equalTo: monthsStack.bottomAnchor, constant: 4),
            monthsErrorLabel.leadingAnchor.constraint(equalTo: monthsStack.leadingAnchor, constant: 16),
            monthsErrorLabel.trailingAnchor.constraint(equalTo: monthsStack.trailingAnchor),

            monthsLabel.centerYAnchor.constraint(equalTo: monthsTextField.centerYAnchor),
            monthsTextField.widthAnchor.constraint(equalToConstant: 57),
            monthsTextField.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    private func setupSaveButtonConstraints() {
        NSLayoutConstraint.activate([
            didSaveNewHabitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -42),
            didSaveNewHabitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            didSaveNewHabitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            didSaveNewHabitButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    // MARK: - Days of week setup

    func setupDaysOfWeekStack() {
        if daysOfWeekStack.arrangedSubviews.isEmpty {
            configureDaysOfWeekStack()
            addDayViewsToStack()
        } else {
            updateCheckboxes()
        }
    }

    private func configureDaysOfWeekStack() {
        daysOfWeekStack.axis = .horizontal
        daysOfWeekStack.distribution = .fillEqually
        daysOfWeekStack.spacing = 4
        daysOfWeekStack.translatesAutoresizingMaskIntoConstraints = false
    }

    private func addDayViewsToStack() {
        let dayTitles = ["пн", "вт", "ср", "чт", "пт", "сб", "вс"]

        for day in 0..<7 {
            let dayContainer = createDayContainer(for: day)
            let dayStack = createDayStack()
            dayContainer.addSubview(dayStack)

            let dayLabel = createDayLabel(with: dayTitles[day])
            let checkboxImageView = createCheckboxImageView(isSelected: selectedDays[day])

            dayStack.addArrangedSubview(dayLabel)
            dayStack.addArrangedSubview(checkboxImageView)

            setupConstraints(for: dayStack, in: dayContainer, checkboxImageView: checkboxImageView)
            daysOfWeekStack.addArrangedSubview(dayContainer)
        }
    }

    private func createDayContainer(for day: Int) -> UIView {
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
        return dayContainer
    }

    private func createDayStack() -> UIStackView {
        let dayStack = UIStackView()
        dayStack.axis = .vertical
        dayStack.alignment = .center
        dayStack.spacing = 8
        dayStack.translatesAutoresizingMaskIntoConstraints = false
        return dayStack
    }

    private func createDayLabel(with title: String) -> UILabel {
        let dayLabel = UILabel()
        dayLabel.text = title
        dayLabel.font = AppStyle.Fonts.regularFont(size: 16)
        dayLabel.textAlignment = .center
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        return dayLabel
    }

    private func createCheckboxImageView(isSelected: Bool) -> UIImageView {
        let checkboxImageView = UIImageView()
        checkboxImageView.image = UIImage(named: isSelected ? "CheckedCheckbox" : "UncheckedCheckbox")
        checkboxImageView.contentMode = .scaleAspectFit
        checkboxImageView.isUserInteractionEnabled = false
        checkboxImageView.tag = 999
        checkboxImageView.translatesAutoresizingMaskIntoConstraints = false
        return checkboxImageView
    }

    private func setupConstraints(
        for dayStack: UIStackView,
        in dayContainer: UIView,
        checkboxImageView: UIImageView
    ) {
        NSLayoutConstraint.activate([
            dayStack.centerXAnchor.constraint(equalTo: dayContainer.centerXAnchor),
            dayStack.centerYAnchor.constraint(equalTo: dayContainer.centerYAnchor),
            dayContainer.heightAnchor.constraint(equalToConstant: 71),
            checkboxImageView.widthAnchor.constraint(equalToConstant: 24),
            checkboxImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    private func updateCheckboxes() {
        for (index, subview) in daysOfWeekStack.arrangedSubviews.enumerated() {
            guard let checkboxImageView = subview.viewWithTag(999) as? UIImageView else { continue }
            checkboxImageView.image = UIImage(
                named: selectedDays[index] ? "CheckedCheckbox" : "UncheckedCheckbox"
            )
        }
    }

    // MARK: - Setup height for error labels

    func setupErrorLabelHeight() {
        habitErrorLabelHeightConstraint = createHeightConstraint(for: habitErrorLabel)
        timesPerDayErrorLabelHeightConstraint = createHeightConstraint(for: timesPerDayErrorLabel)
        daysOfWeekErrorLabelHeightConstraint = createHeightConstraint(for: daysOfWeekErrorLabel)

        NSLayoutConstraint.activate([
            habitErrorLabelHeightConstraint,
            timesPerDayErrorLabelHeightConstraint,
            daysOfWeekErrorLabelHeightConstraint
        ])
    }

    private func createHeightConstraint(for label: UILabel) -> NSLayoutConstraint {
        return label.heightAnchor.constraint(equalToConstant: 0)
    }
}
