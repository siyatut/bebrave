//
//  HabitsViewController+NewHabitDelegate.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 23/12/2567 BE.
//

import UIKit

// MARK: - Delegate Protocol

protocol HabitDelegate: AnyObject {
    func didAddNewHabit(_ habit: Habit)
    func didEditHabit(_ habit: Habit)
}

// MARK: - NewHabitDelegate

extension HabitsViewController: HabitDelegate {

    func didAddNewHabit(_ habit: Habit) {
        viewModel.addHabit(habit)

        let newIndex = viewModel.habits.count - 1
        let indexPath = IndexPath(item: newIndex, section: 0)

        collectionView.performBatchUpdates({
            collectionView.insertItems(at: [indexPath])
        }, completion: { _ in
            self.updateEmptyState()
        })
    }

    func didEditHabit(_ habit: Habit) {
        viewModel.updateHabit(habit)
        if let index = viewModel.habits.firstIndex(where: { $0.id == habit.id }) {
            let indexPath = IndexPath(item: index, section: 0)
            collectionView.reloadItems(at: [indexPath])
        }
    }

    func deleteHabit(_ habit: Habit) {
        guard let index = viewModel.habits.firstIndex(where: { $0.id == habit.id }) else {
            print("Habit not found or already deleted")
            return
        }

        let indexPath = IndexPath(item: index, section: 0)

        UIView.animate(withDuration: 0.3, animations: {
            if let cell = self.collectionView.cellForItem(at: indexPath) {
                cell.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
                cell.alpha = 0
            }
        }, completion: { _ in
            self.viewModel.deleteHabit(id: habit.id)
        })
    }
}
