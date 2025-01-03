//
//  HabitsViewController+Notifications.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 3/1/2568 BE.
//

import UIKit

extension HabitsViewController {
    
    @objc func handleDeleteHabit(_ notification: Notification) {
        
        guard let cell = notification.object as? HabitsCell,
              let indexPath = collectionView.indexPath(for: cell) else { return }
        
        deleteHabit(at: indexPath)
    }
    
    @objc func handleChangeHabitTap(_ notification: Notification) {
        guard let cell = notification.object as? HabitsCell,
              let indexPath = collectionView.indexPath(for: cell) else { return }
        
        let habit = habits[indexPath.row]
        let changeHabitVC = ChangeHabitViewController(habit: habit)
        self.navigationController?.pushViewController(changeHabitVC, animated: true)
    }
}
