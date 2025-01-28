//
//  NewHabitView+Validation.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 31/12/2567 BE.
//

import UIKit

extension BaseHabitViewController {
    
    func validateFields(showErrors: Bool = false) -> Bool {
        var isValid = true
        resetErrorStates(animated: true)
        
        isValid = validateHabitTextField(showErrors: showErrors) && isValid
        isValid = validateTimesPerDayTextField(showErrors: showErrors) && isValid
        isValid = validateSelectedDays(showErrors: showErrors) && isValid
        isValid = validateMonthsTextField(showErrors: showErrors) && isValid
        
        animateLayoutChanges()
        return isValid
    }

    private func validateHabitTextField(showErrors: Bool) -> Bool {
        guard let text = habitTextField.text, !text.isEmpty else {
            if showErrors {
                showError(
                    for: habitTextField,
                    errorLabel: habitErrorLabel,
                    errorText: "А что именно?",
                    errorHeightConstraint: habitErrorLabelHeightConstraint
                )
            }
            return false
        }
        return true
    }

    private func validateTimesPerDayTextField(showErrors: Bool) -> Bool {
        if let text = timesPerDayTextField.text, text.isEmpty {
            timesPerDayTextField.text = "1"
        } else if let value = Int(timesPerDayTextField.text ?? ""), value > 10 {
            if showErrors {
                showError(
                    for: timesPerDayTextField,
                    errorLabel: timesPerDayErrorLabel,
                    errorText: "Максимум 10, мы против насилия над собой",
                    errorHeightConstraint: timesPerDayErrorLabelHeightConstraint
                )
            }
            return false
        }
        return true
    }

    private func validateSelectedDays(showErrors: Bool) -> Bool {
        if !selectedDays.contains(true) {
            if showErrors {
                daysOfWeekErrorLabel.text = "Если не выбрать ни одного дня, в трекере нет смысла"
                daysOfWeekErrorLabel.isHidden = false
                daysOfWeekErrorLabelHeightConstraint.constant = 15
                highlightDaysOfWeekStack(with: AppStyle.Colors.errorColor)
            }
            return false
        } else {
            daysOfWeekErrorLabel.isHidden = true
            daysOfWeekErrorLabelHeightConstraint.constant = 0
            highlightDaysOfWeekStack(with: AppStyle.Colors.borderColor)
        }
        return true
    }

    private func validateMonthsTextField(showErrors: Bool) -> Bool {
        if let text = monthsTextField.text, text.isEmpty {
            monthsTextField.text = "1"
        } else if let value = Int(monthsTextField.text ?? ""), value > 125 {
            if showErrors {
                monthsErrorLabel.text = "Максимум 125, но мы восхищены горизонтом\n" +
                "планирования — это больше 10 лет!"
                monthsErrorLabel.isHidden = false
                monthsTextField.layer.borderColor = AppStyle.Colors.errorColor.cgColor
            }
            return false
        }
        return true
    }

    private func showError(
        for textField: UITextField,
        errorLabel: UILabel,
        errorText: String,
        errorHeightConstraint: NSLayoutConstraint
    ) {
        errorLabel.text = errorText
        errorLabel.isHidden = false
        textField.layer.borderColor = AppStyle.Colors.errorColor.cgColor
        errorHeightConstraint.constant = 15
    }

    func resetErrorStates(animated: Bool = true) {
        habitErrorLabel.isHidden = true
        timesPerDayErrorLabel.isHidden = true
        daysOfWeekErrorLabel.isHidden = true
        monthsErrorLabel.isHidden = true
        
        habitTextField.layer.borderColor = AppStyle.Colors.borderColor.cgColor
        timesPerDayTextField.layer.borderColor = AppStyle.Colors.borderColor.cgColor
        monthsTextField.layer.borderColor = AppStyle.Colors.borderColor.cgColor
        highlightDaysOfWeekStack(with: AppStyle.Colors.borderColor)
        
        habitErrorLabelHeightConstraint.constant = 0
        timesPerDayErrorLabelHeightConstraint.constant = 0
        daysOfWeekErrorLabelHeightConstraint.constant = 0
        
        if animated {
            animateLayoutChanges()
        } else {
            view.layoutIfNeeded()
        }
    }
    
    func highlightDaysOfWeekStack(with color: UIColor) {
        for view in daysOfWeekStack.arrangedSubviews {
            view.layer.borderColor = color.cgColor
            view.layer.borderWidth = AppStyle.Sizes.borderWidth
        }
    }
}
