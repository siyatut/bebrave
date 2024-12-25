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
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return habits.count + 1
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        do {
            if indexPath.item < habits.count {
                print("Returning habit cell for index \(indexPath.item)")
                let habitCell: HabitsCell = try collectionView.dequeueCell(
                    withReuseIdentifier: CustomElement.habitsCell.rawValue,
                    for: indexPath
                )
                let habit = habits[indexPath.item]
                print("Configuring habit cell with habit: \(habit.title)")
                habitCell.configure(with: habit)
                return habitCell
            }
            else if indexPath.item == habits.count {
                print("Returning diary write cell for indexPath: \(indexPath)")
                let diaryCell: DiaryWriteCell = try collectionView.dequeueCell(
                    withReuseIdentifier: CustomElement.writeDiaryCell.rawValue,
                    for: indexPath
                )
                return diaryCell
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

