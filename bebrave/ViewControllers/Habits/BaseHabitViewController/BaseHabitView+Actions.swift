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
    
    func createHabitFromFields() -> Habit? {
        guard let title = habitTextField.text,
              let frequencyText = timesPerDayTextField.text,
              let frequency = Int(frequencyText),
              let monthFrequencyText = monthsTextField.text,
              let monthFrequency = Int(monthFrequencyText) else {
            return nil
        }
        
        return Habit.createNew(
            title: title,
            frequency: frequency,
            monthFrequency: monthFrequency,
            daysOfWeek: selectedDays
        )
    }
}


//    @objc func createHabitAction() {
//        hasAttemptedSave = true
//        let isValid = validateFields(showErrors: true)
//
//        guard isValid else {
//            print("После нажатия на кнопку. Есть ошибки. Кнопка недоступна")
//            updateButtonState()
//            return
//        }
//        guard let title = habitTextField.text,
//              let frequencyText = timesPerDayTextField.text,
//              let frequency = Int(frequencyText) else {
//            print("Не удалось получить данные для создания привычки.")
//            updateButtonState()
//            return
//        }
//        let newHabit = Habit(
//            id: UUID(),
//            title: title,
//            frequency: frequency,
//            progress: [:],
//            skipDates: []
//        )
//        UserDefaultsManager.shared.addHabit(newHabit)
//
//        delegate?.willHideEmptyStateView()
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            self.delegate?.didAddNewHabit(newHabit)
//            print("Привычка сохранена: \(newHabit.title)")
//            self.dismiss(animated: true, completion: nil)
//        }
//    }
//
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//        hasAttemptedSave = true
//        let isValid = validateFields(showErrors: true)
//
//        guard isValid else {
//            print("После нажатия на экран есть ошибки. Кнопка недоступна")
//            updateButtonState()
//            return
//        }
//    }
