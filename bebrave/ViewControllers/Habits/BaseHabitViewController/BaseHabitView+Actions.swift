//
//  NewHabitView+Actions.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 31/12/2567 BE.
//

import UIKit

extension BaseHabitViewController {
    
    @objc func checkboxTapped(_ sender: UITapGestureRecognizer) {
        guard let index = sender.view?.tag else { return }
        selectedDays[index].toggle()
        
        if let dayContainer = sender.view,
           let checkboxImageView = dayContainer.viewWithTag(999) as? UIImageView {
            let imageName = selectedDays[index] ? "CheckedCheckbox" : "UncheckedCheckbox"
            checkboxImageView.image = UIImage(named: imageName)
        }
    }
    
    @objc func saveHabit() {
        hasAttemptedSave = true
        // TODO: - Cейчас нет времени разобраться, но почему здесь true? При этом работает всё нормально вроде...
        let isValid = validateFields(showErrors: true)
        
        guard isValid else {
            print("Поля содержат ошибки. Кнопка недоступна.")
            updateButtonState()
            return
        }
        
        guard let habit = createHabitFromFields() else {
            print("Не удалось создать объект привычки.")
            updateButtonState()
            return
        }
        
        handleHabitSave(habit)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        hasAttemptedSave = true
        let isValid = validateFields(showErrors: true)
        
        guard isValid else {
            print("После нажатия на экран есть ошибки. Кнопка недоступна.")
            updateButtonState()
            return
        }
    }
}
