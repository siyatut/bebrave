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
    
    private var habits: [Habit] = []

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

// MARK: — UICollectionViewDelegate

extension HabitsViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        let sections = habits.isEmpty ? 1 : 2 // здесь 2, потому что возвращаются обе секции, но если нет привычек, itemCount = 0
        print("Calculating number of sections. Habits count: \(habits.count). Returning sections: \(sections)")
        return sections
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemCount: Int
        if section == 0 {
            itemCount = habits.isEmpty ? 1 : 0
        } else if section == 1 {
            itemCount = habits.count + 1
        } else {
            itemCount = 0
        }
        print("Calculating number of items in section \(section). Habits count: \(habits.count). Returning items: \(itemCount)")
        return itemCount
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        do {
            if habits.isEmpty && indexPath.section == 0 {
                print("Returning empty state cell for indexPath: \(indexPath)")
                let emptyStateCell: EmptyStateCell = try collectionView.dequeueCell(
                    withReuseIdentifier: "EmptyStateCell",
                    for: indexPath
                )
                return emptyStateCell
            }
            
            if indexPath.section == 1 {
                if indexPath.item == habits.count {
                    print("Returning diary write cell for indexPath: \(indexPath)")
                    let diaryCell: DiaryWriteCell = try collectionView.dequeueCell(
                        withReuseIdentifier: CustomElement.writeDiaryCell.rawValue,
                        for: indexPath
                    )
                    return diaryCell
                } else {
                    print("Returning habit cell for index \(indexPath.item)")
                    let habitCell: HabitsCell = try collectionView.dequeueCell(
                        withReuseIdentifier: CustomElement.habitsCell.rawValue,
                        for: indexPath
                    )
                    habitCell.delegate = self
                    let habit = habits[indexPath.item]
                    print("Configuring habit cell with habit: \(habit.title)")
                    habitCell.configure(with: habit)
                    return habitCell
                }
            }
            
            throw CellError.unhandledSectionOrIndexPath(indexPath)
        } catch {
            assertionFailure("Failed to load cell: \(error)")
            return UICollectionViewCell()
        }
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        do {
            guard let customElement = CustomElement(rawValue: kind) else {
                throw SupplementaryViewError.unexpectedKind(kind)
            }
            
            switch customElement {
            case .collectionFooter:
                let footer = try collectionView.dequeueSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: CustomElement.collectionFooter.rawValue,
                    for: indexPath
                ) as AddNewHabitView
                footer.backgroundColor = AppStyle.Colors.backgroundColor
                footer.parentFooterViewController = self
                return footer
                
            case .collectionHeader:
                let header = try collectionView.dequeueSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: CustomElement.collectionHeader.rawValue,
                    for: indexPath
                ) as HeaderDaysCollectionView
                header.backgroundColor = AppStyle.Colors.backgroundColor
                header.parentHeaderViewController = self
                headerView = header
                return header
                
            case .outlineBackground:
                let outlineBackground = try collectionView.dequeueSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: CustomElement.outlineBackground.rawValue,
                    for: indexPath
                ) as OutlineBackgroundView
                return outlineBackground
                
            default:
                throw SupplementaryViewError.unhandledCustomElement(customElement)
            }
        } catch {
            assertionFailure("Failed to load supplementary view: \(error)")
            return UICollectionReusableView()
        }
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

