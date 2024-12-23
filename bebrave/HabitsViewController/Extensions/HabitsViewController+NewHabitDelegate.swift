//
//  HabitsViewController+NewHabitDelegate.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 23/12/2567 BE.
//

import UIKit

// MARK: - NewHabitDelegate

extension HabitsViewController: NewHabitDelegate {
    func didAddNewHabit(_ habit: Habit) {
        habits.append(habit)
        collectionView.reloadData()
    }
    
    func didDeleteHabit(at indexPath: IndexPath) {
        print("Attempting to delete habit at indexPath: \(indexPath)")
        print("Current habits count: \(habits.count)")
        
        // Проверяем, что секция и индекс корректны
        guard indexPath.section == 1, indexPath.item < habits.count else {
            print("Invalid indexPath for deletion: \(indexPath)")
            return
        }
        
        // Получаем привычку, которую нужно удалить
        let habitToDelete = habits[indexPath.item]
        print("Habit to delete: \(habitToDelete.title)")
        
        // Удаляем привычку из массива
        habits.remove(at: indexPath.item)
        print("Habit removed from array. New habits count: \(habits.count)")
        
        // Удаляем привычку из UserDefaults
        UserDefaultsManager.shared.deleteHabit(id: habitToDelete.id)
        print("Habit deleted from UserDefaults. ID: \(habitToDelete.id)")
        
        // Анимация удаления
        collectionView.performBatchUpdates({
            print("Deleting item at indexPath: \(indexPath) from collectionView")
            collectionView.deleteItems(at: [indexPath])
        }, completion: { _ in
            print("Batch update completed.")
            if self.habits.isEmpty {
                print("Habits array is empty. Reloading entire collectionView.")
                self.collectionView.reloadData()
            }
        })
    }
}

