//
//  HabitsViewController+HabitsCellDelegate.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 9/1/2568 BE.
//

import UIKit

extension HabitsViewController: HabitCellDelegate {
    
    func editHabit(habit: Habit) {
        let changeHabitVC = ChangeHabitViewController(habit: habit)
        navigationController?.pushViewController(changeHabitVC, animated: true)
    }
    
    func deleteHabit(habit: Habit) {
        deleteHabit(habit)
    }
    
    
    func markHabitAsNotCompleted(habit: Habit) {
        var updatedHabit = habit
        updatedHabit.undoCompletion()
        UserDefaultsManager.shared.updateHabit(updatedHabit)
        
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index] = updatedHabit
            let indexPath = IndexPath(item: index, section: 0)
            collectionView.reloadItems(at: [indexPath])
        }
    }

    func skipToday(habit: Habit) {
        var updatedHabit = habit
        updatedHabit.skipToday()
        UserDefaultsManager.shared.updateHabit(updatedHabit)
        
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index] = updatedHabit
            let indexPath = IndexPath(item: index, section: 0)
            collectionView.reloadItems(at: [indexPath])
        }
    }
}
