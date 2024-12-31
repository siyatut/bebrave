//
//  NewHabitView+Actions.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 31/12/2567 BE.
//

import UIKit

extension NewHabitViewController {
    
    @objc func checkboxTapped(_ sender: UITapGestureRecognizer) {
        guard let index = sender.view?.tag else { return }
        selectedDays[index].toggle()
        
        if let checkboxImageView = sender.view as? UIImageView {
            let imageName = selectedDays[index] ? "UncheckedCheckbox" : "CheckedCheckbox"
            checkboxImageView.image = UIImage(named: imageName)
        }
    }
    
    @objc func addNewHabitButtonTapped() {
        hasAttemptedSave = true
        let isValid = validateFields(showErrors: true)
        
        guard isValid else {
            print("После нажатия на кнопку. Есть ошибки. Кнопка недоступна")
            updateButtonState()
            return
        }
        guard let title = habitTextField.text,
              let frequencyText = timesPerDayTextField.text,
              let frequency = Int(frequencyText) else {
            print("Не удалось получить данные для создания привычки.")
            updateButtonState()
            return
        }
        let newHabit = Habit(
            id: UUID(),
            title: title,
            frequency: frequency,
            progress: [:]
        )
        UserDefaultsManager.shared.addHabit(newHabit)
        delegate?.didAddNewHabit(newHabit)
        print("Привычка сохранена: \(newHabit.title)")
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        hasAttemptedSave = true
        let isValid = validateFields(showErrors: true)
        
        guard isValid else {
            print("После нажатия на экран есть ошибки. Кнопка недоступна")
            updateButtonState()
            return
        }
    }
}
