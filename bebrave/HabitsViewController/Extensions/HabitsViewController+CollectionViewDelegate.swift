//
//  HabitsViewController+CollectionViewDelegate.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 23/12/2567 BE.
//

import UIKit

// MARK: - UICollectionViewDelegate

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

// MARK: - Print selected habit

extension HabitsViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0, indexPath.item < habits.count {
            let selectedHabit = habits[indexPath.item]
            print("Selected habit: \(selectedHabit.title)")
        }
    }
}
