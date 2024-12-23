//
//  HabitsViewController+SwipeActions.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 23/12/2567 BE.
//

import UIKit
import SwipeCellKit

// MARK: - SwipeCollectionViewCellDelegate

extension HabitsViewController: SwipeCollectionViewCellDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        editActionsForItemAt indexPath: IndexPath,
        for orientation: SwipeActionsOrientation
    ) -> [SwipeAction]? {
        print("Swipe detected at indexPath: \(indexPath), orientation: \(orientation)")
        
        guard orientation == .right else {
            print("Invalid swipe orientation: \(orientation). Returning nil.")
            return nil
        }
        
        guard indexPath.section == 1, indexPath.item < habits.count else {
            print("Invalid swipe request: section \(indexPath.section), item \(indexPath.item). Returning nil.")
            return nil
        }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Удалить") { [weak self] action, indexPath in
            print("Delete action triggered for indexPath: \(indexPath)")
            self?.didDeleteHabit(at: indexPath)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        return [deleteAction]
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        editActionsOptionsForItemAt indexPath: IndexPath,
        for orientation: SwipeActionsOrientation
    ) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}


