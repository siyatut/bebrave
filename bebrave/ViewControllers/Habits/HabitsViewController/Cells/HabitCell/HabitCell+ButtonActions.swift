//
//  HabitCell+ButtonActions.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 13/1/2568 BE.
//

import UIKit

extension HabitCell {
    
    @objc func editHabit() {
        guard let habit = habit else { return }
        delegate?.habitCell(self, didTriggerAction: .edit, for: habit)
        resetPosition()
    }
    
    @objc func skipHabit() {
        guard let habit = habit else { return }
        delegate?.habitCell(self, didTriggerAction: .skipToday, for: habit)
        resetPosition()
    }
    
    @objc func cancelHabit() {
        guard let habit = habit else { return }
        if habit.skipDates.contains(Calendar.current.startOfDay(for: Date())) {
            delegate?.habitCell(self, didTriggerAction: .undoSkip, for: habit)
        } else {
            delegate?.habitCell(self, didTriggerAction: .unmarkCompletion, for: habit)
        }
        resetPosition()
    }
    
    @objc func confirmDelete() {
        guard let habit = habit else { return }
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        let titleFont = AppStyle.Fonts.boldFont(size: 16)
        let messageFont = AppStyle.Fonts.regularFont(size: 12)
        
        let titleAttributes: [NSAttributedString.Key: Any] = [.font: titleFont, .foregroundColor: AppStyle.Colors.secondaryColor]
        let messageAttributes: [NSAttributedString.Key: Any] = [.font: messageFont, .foregroundColor: AppStyle.Colors.textColor]
        
        let attributedTitle = NSAttributedString(string: "Точно удаляем привычку?", attributes: titleAttributes)
        let attributedMessage = NSAttributedString(string: "восстановить прогресс не выйдет", attributes: messageAttributes)
        
        alert.setValue(attributedTitle, forKey: "attributedTitle")
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { _ in
            self.resetPosition()
        }
        
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.habitCell(self, didTriggerAction: .delete, for: habit)
            self.resetPosition()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        if let viewController = self.window?.rootViewController {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
