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
            updateCollectionView(for: habit.id)

        case .skipToday:
            viewModel.skipHabit(id: habit.id)
            updateCollectionView(for: habit.id)

        case .unmarkCompletion:
            viewModel.undoCompletion(id: habit.id)
            updateCollectionView(for: habit.id)

        case .undoSkip:
            viewModel.undoSkipHabit(id: habit.id)
            updateCollectionView(for: habit.id)
        }
    }

    private func updateCollectionView(for habitId: UUID) {
        if let index = viewModel.habits.firstIndex(where: { $0.id == habitId }) {
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
