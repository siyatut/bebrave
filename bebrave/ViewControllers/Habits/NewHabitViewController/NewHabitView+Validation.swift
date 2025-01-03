//
//  NewHabitView+Validation.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 31/12/2567 BE.
//

import UIKit

extension NewHabitViewController {
    
    func validateFields(showErrors: Bool = false) -> Bool {
        var isValid = true
        resetErrorStates(animated: true)
        
        if habitTextField.text?.isEmpty ?? true {
            isValid = false
            if showErrors {
                habitErrorLabel.text = "А что именно?"
                habitErrorLabel.isHidden = false
                habitTextField.layer.borderColor = AppStyle.Colors.errorColor.cgColor
                habitErrorLabelHeightConstraint.constant = 15
            }
        }
        
        if let text = timesPerDayTextField.text, text.isEmpty {
            timesPerDayTextField.text = "1"
        } else if let value = Int(timesPerDayTextField.text ?? ""), value > 10 {
            isValid = false
            if showErrors {
                timesPerDayErrorLabel.text = "Максимум 10, мы против насилия над собой"
                timesPerDayErrorLabel.isHidden = false
                timesPerDayTextField.layer.borderColor = AppStyle.Colors.errorColor.cgColor
                timesPerDayErrorLabelHeightConstraint.constant = 15
            }
        }
        
        if !selectedDays.contains(true) {
            isValid = false
            if showErrors {
                daysOfWeekErrorLabel.text = "Если не выбрать ни одного дня, в трекере нет смысла"
                daysOfWeekErrorLabel.isHidden = false
                daysOfWeekErrorLabelHeightConstraint.constant = 15
                highlightDaysOfWeekStack(with: AppStyle.Colors.errorColor)
            }
        } else {
            daysOfWeekErrorLabel.isHidden = true
            daysOfWeekErrorLabelHeightConstraint.constant = 0
            highlightDaysOfWeekStack(with: AppStyle.Colors.borderColor)
        }
        
        if let text = monthsTextField.text, text.isEmpty {
            monthsTextField.text = "1"
        } else if let value = Int(monthsTextField.text ?? ""), value > 125 {
            isValid = false
            if showErrors {
                monthsErrorLabel.text = "Максимум 125, но мы восхищены горизонтом\nпланирования — это больше 10 лет!"
                monthsErrorLabel.isHidden = false
                monthsTextField.layer.borderColor = AppStyle.Colors.errorColor.cgColor
            }
        }
        
        animateLayoutChanges()
        return isValid
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
