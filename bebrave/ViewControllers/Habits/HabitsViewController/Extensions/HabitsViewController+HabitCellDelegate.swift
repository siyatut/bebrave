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
            deleteHabit(habit)
        case .skipToday:
            var updatedHabit = habit
            updatedHabit.skipToday()
            UserDefaultsManager.shared.updateHabit(updatedHabit)
            reloadHabit(updatedHabit)
        case .unmarkCompletion:
            var updatedHabit = habit
            updatedHabit.undoCompletion()
            UserDefaultsManager.shared.updateHabit(updatedHabit)
            reloadHabit(updatedHabit)
        case .undoSkip:
            var updatedHabit = habit
            updatedHabit.undoSkip()
            UserDefaultsManager.shared.updateHabit(updatedHabit)
            reloadHabit(updatedHabit)
        }
    }
    
    private func reloadHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index] = habit
            let indexPath = IndexPath(item: index, section: 0)
            collectionView.reloadItems(at: [indexPath])
        }
    }
    
    func habitCellDidStartSwipe(_ cell: HabitCell) {
        if swipedCell != cell {
            swipedCell?.resetPosition()
            swipedCell = cell
        }
    }
}
