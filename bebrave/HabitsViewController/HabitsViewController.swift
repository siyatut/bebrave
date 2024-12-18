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
        super.init(collectionViewLayout: HabitsViewController.createLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Create layout
    
    static func createLayout() -> UICollectionViewLayout {
        let provider: UICollectionViewCompositionalLayoutSectionProvider = { section, environment in

            if section == 0 {
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)
                    )
                )
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(312)
                    ),
                    subitems: [item]
                )
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 12, leading: 12, bottom: 0, trailing: 12)
                return section
            }
            
            let background = NSCollectionLayoutSupplementaryItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                ),
                elementKind: CustomElement.outlineBackground.rawValue,
                containerAnchor: .init(edges: .all)
            )
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60)
                ),
                supplementaryItems: [background]
            )
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60)
                ),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 0, leading: 12, bottom: 0, trailing: 12)
            section.interGroupSpacing = 8
            return section
        }
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(70)
            ),
            elementKind: CustomElement.collectionHeader.rawValue,
            alignment: .top,
            absoluteOffset: .init(x: 0, y: -24)
        )
        header.extendsBoundary = true
        header.contentInsets = .init(top: 0, leading: 12, bottom: 0, trailing: 12)
        
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(48)
            ),
            elementKind: CustomElement.collectionFooter.rawValue,
            alignment: .bottom,
            absoluteOffset: .init(x: 0, y: 24)
        )
        footer.extendsBoundary = true
        footer.contentInsets = .init(top: 0, leading: 12, bottom: 0, trailing: 12)
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.boundarySupplementaryItems = [header, footer]
        return UICollectionViewCompositionalLayout(sectionProvider: provider, configuration: configuration)
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
        habits = UserDefaultsManager.shared.loadHabits()
        print("Habits loaded: \(habits.map { $0.title })")
        collectionView.reloadData()
        DispatchQueue.main.async {
            self.updateCalendarLabel()
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
        return habits.isEmpty ? 1 : 2
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
        
        print("Section \(section): Expected \(itemCount) items.")
        return itemCount
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        do {
            if habits.isEmpty && indexPath.section == 0 {
                print("Loading empty state cell.")
                let emptyStateCell: EmptyStateCell = try collectionView.dequeueCell(
                    withReuseIdentifier: "EmptyStateCell",
                    for: indexPath
                )
                return emptyStateCell
            }
            
            if indexPath.section == 1 {
                if indexPath.item == habits.count {
                    print("Loading diary cell.")
                    let diaryCell: DiaryWriteCell = try collectionView.dequeueCell(
                        withReuseIdentifier: CustomElement.writeDiaryCell.rawValue,
                        for: indexPath
                    )
                    return diaryCell
                } else {
                    print("Loading habit cell at index \(indexPath.item).")
                    let habitCell: HabitsCell = try collectionView.dequeueCell(
                        withReuseIdentifier: CustomElement.habitsCell.rawValue,
                        for: indexPath
                    )
                    habitCell.delegate = self
                    let habit = habits[indexPath.item]
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
        print("Deleting habit at indexPath: \(indexPath)")
        
        guard indexPath.section == 1, indexPath.item < habits.count else {
            print("Invalid indexPath for deletion: \(indexPath)")
            return
        }
        
        habits.remove(at: indexPath.item)
        print("Deleted habit: \(indexPath.item)")
        
        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: [indexPath])
        }, completion: { _ in
            if self.habits.isEmpty {
                print("All habits removed. Reloading section.")
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
        
        guard orientation == .right else { return nil }
        guard indexPath.section == 1, indexPath.item < habits.count else {
            print("Invalid swipe request: section \(indexPath.section), item \(indexPath.item)")
            return nil
        }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Удалить") { [weak self] action, indexPath in
            guard let self = self else { return }
            self.didDeleteHabit(at: indexPath)
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
