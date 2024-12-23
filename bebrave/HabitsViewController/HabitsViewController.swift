//
//  HabitsViewController.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 14/2/2567 BE.
//

#warning("№1: Добавить действия со свайпами, затем перейти к пункту ниже")

#warning("№2: Добавить нужную отрисовку в чекбоксе по нажатию + степень закрашивания ячейки + изменение процента и числа 1/2, например")

#warning("№3: Нужно будет ещё добавить условия для пропуска привычки, когда по каким-то причинам пользователь не хочет выполнять её + условия, при котором она будет считаться невыполненной")

import UIKit
import SwipeCellKit

// MARK: - Delegate Protocol

protocol NewHabitDelegate: AnyObject {
    func didAddNewHabit(_ habit: Habit)
}

class HabitsViewController: UICollectionViewController {
 
// MARK: - Data Source
    
    var habits: [Habit] = []

// MARK: - Properties
    
    var headerView: HeaderDaysCollectionView?
    
// MARK: - UI components
    
    let historyButton = UIButton()
    let calendarLabel = UILabel()
    
// MARK: — Init
    
    init() {
        super.init(collectionViewLayout: HabitsLayout.createLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Lifecycle view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppStyle.Colors.backgroundColor
        setupHistoryButton()
        setupCalendarLabel()
        
        collectionView.register(
            HabitsCell.self,
            forCellWithReuseIdentifier: CustomElement.habitsCell.rawValue
        )
        collectionView.register(
            DiaryWriteCell.self,
            forCellWithReuseIdentifier: CustomElement.writeDiaryCell.rawValue
        )
        collectionView.register(
            HeaderDaysCollectionView.self,
            forSupplementaryViewOfKind: CustomElement.collectionHeader.rawValue,
            withReuseIdentifier: CustomElement.collectionHeader.rawValue
        )
        collectionView.register(
            OutlineBackgroundView.self,
            forSupplementaryViewOfKind: CustomElement.outlineBackground.rawValue,
            withReuseIdentifier: CustomElement.outlineBackground.rawValue
        )
        collectionView.register(
            AddNewHabitView.self,
            forSupplementaryViewOfKind: CustomElement.collectionFooter.rawValue,
            withReuseIdentifier: CustomElement.collectionFooter.rawValue
        )
        collectionView.register(
            EmptyStateCell.self,
            forCellWithReuseIdentifier: "EmptyStateCell"
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View will appear. Loading habits.")
        
        // Загружаем привычки из UserDefaults
        habits = UserDefaultsManager.shared.loadHabits()
        print("Habits loaded: \(habits.map { $0.title })")
        
        // Обновляем интерфейс
        collectionView.reloadData()
        print("CollectionView reloaded. Current habits count: \(habits.count)")
        
        DispatchQueue.main.async {
            self.updateCalendarLabel()
            print("Calendar label updated.")
        }
    }
    
// MARK: - Action
    
    @objc func historyButtonTapped() {
        let history = HistoryViewController()
        self.navigationController?.pushViewController(history, animated: true)
    }
}

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

extension HabitsViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0, indexPath.item < habits.count {
            let selectedHabit = habits[indexPath.item]
            print("Selected habit: \(selectedHabit.title)")
        }
    }
}

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

