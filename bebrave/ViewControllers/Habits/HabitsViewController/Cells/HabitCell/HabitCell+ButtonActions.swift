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
        let alert = UIAlertController(title: "Точно удаляем привычку?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel) { _ in
            self.resetPosition()
        })
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.habitCell(self, didTriggerAction: .delete, for: habit)
            self.resetPosition()
        })
        
        if let viewController = self.window?.rootViewController {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
