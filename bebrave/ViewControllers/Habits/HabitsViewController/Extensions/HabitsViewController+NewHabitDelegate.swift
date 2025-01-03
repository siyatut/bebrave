//
//  HabitsViewController+NewHabitDelegate.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 23/12/2567 BE.
//

import UIKit

// MARK: - Delegate Protocol

protocol NewHabitDelegate: AnyObject {
    func didAddNewHabit(_ habit: Habit)
    func willHideEmptyStateView()
}

// MARK: - NewHabitDelegate

extension HabitsViewController: NewHabitDelegate {
    func didAddNewHabit(_ habit: Habit) {
        habits.append(habit)
        collectionView.reloadData()
        updateEmptyState(animated: true)
    }
    
    func willHideEmptyStateView() {
        if habits.isEmpty {
            emptyStateView.animateVisibility(isVisible: false, transformEffect: true)
        }
    }
    
    func deleteHabit(at indexPath: IndexPath) {
        guard indexPath.item < habits.count else {
            print("Invalid index or attempt to delete DiaryWriteCell")
            return
        }
        
        let habitToDelete = habits[indexPath.item]
        
        UIView.animate(withDuration: 0.3, animations: {
            if let cell = self.collectionView.cellForItem(at: indexPath) {
                cell.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
                cell.alpha = 0
            }
        }, completion: { _ in
            self.habits.remove(at: indexPath.item)
            UserDefaultsManager.shared.deleteHabit(id: habitToDelete.id)
            self.collectionView.performBatchUpdates({
                self.collectionView.deleteItems(at: [indexPath])
            }, completion: { _ in
                self.updateEmptyState(animated: true)
            })
        })
    }
}

