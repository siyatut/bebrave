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
        guard let oldHabit = habit, let viewModel = viewModel else { return }
        delegate?.habitCell(self, didTriggerAction: .skipToday, for: oldHabit)

        if let updatedHabit = viewModel.habits.first(where: { $0.id == oldHabit.id }) {
            self.habit = updatedHabit
            applyHabitState(updatedHabit)
        }
        resetPosition()
    }

    @objc func cancelHabit() {
        guard let oldHabit = habit, let viewModel = viewModel else { return }
        let today = Calendar.current.startOfDay(for: Date())
        if let freshHabit = viewModel.habits.first(where: { $0.id == oldHabit.id }) {

            if freshHabit.skipDates.contains(today) {
                delegate?.habitCell(self, didTriggerAction: .undoSkip, for: freshHabit)
            } else {
                delegate?.habitCell(self, didTriggerAction: .unmarkCompletion, for: freshHabit)
            }
        }

        if let updatedHabit = viewModel.habits.first(where: { $0.id == oldHabit.id }) {
            self.habit = updatedHabit
            applyHabitState(updatedHabit)
        }

        resetPosition()
    }

    @objc func confirmDelete() {
        guard let habit = habit else { return }

        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)

        let titleFont = AppStyle.Fonts.boldFont(size: 16)
        let messageFont = AppStyle.Fonts.regularFont(size: 12)

        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: AppStyle.Colors.textColor
        ]
        let messageAttributes: [NSAttributedString.Key: Any] = [
            .font: messageFont,
            .foregroundColor: AppStyle.Colors.textColorSecondary
        ]
        let attributedTitle = NSAttributedString(
            string: "Точно удаляем привычку?",
            attributes: titleAttributes
        )
        let attributedMessage = NSAttributedString(
            string: "прогресс не восстановить",
            attributes: messageAttributes
        )

        alert.setValue(attributedTitle, forKey: "attributedTitle")
        alert.setValue(attributedMessage, forKey: "attributedMessage")

        let cancelAction = UIAlertAction(title: "Оставляем", style: .cancel) { _ in
            self.resetPosition()
        }

        let deleteAction = UIAlertAction(title: "Удаляем", style: .destructive) { [weak self] _ in
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
