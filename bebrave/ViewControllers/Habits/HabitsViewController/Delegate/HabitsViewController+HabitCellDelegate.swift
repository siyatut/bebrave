//
//  HabitsViewController+HabitsCellDelegate.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 9/1/2568 BE.
//

import UIKit

extension HabitsViewController: HabitCellDelegate {

    func habitCell(_ cell: HabitCell, didTriggerAction action: HabitCellAction, for habit: Habit) {
        switch action {
        case .edit:
            let changeHabitVC = EditHabitViewController(habit: habit)
            changeHabitVC.modalPresentationStyle = .pageSheet
            changeHabitVC.delegate = self
            navigationController?.present(changeHabitVC, animated: true, completion: nil)

        case .delete:
            viewModel.deleteHabit(id: habit.id)

        case .skipToday:
            viewModel.skipHabit(id: habit.id)

        case .unmarkCompletion:
            viewModel.undoCompletion(id: habit.id)

        case .undoSkip:
            viewModel.undoSkipHabit(id: habit.id)
        }
    }

    func habitCellDidStartSwipe(_ cell: HabitCell) {
        if swipedCell != cell {
            swipedCell?.resetPosition()
            swipedCell = cell
        }
    }
}
