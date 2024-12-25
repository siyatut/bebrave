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
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: CustomElement.collectionHeader.rawValue,
                for: indexPath
            ) as? HeaderDaysCollectionView else {
                assertionFailure("Failed to dequeue HeaderDaysCollectionView")
                return UICollectionReusableView()
            }
            return header
        }
#warning("Надо, наверное, сделать контроллер обычным и добавить туда коллекцию, чтобы привычку закрепить за tabbar и сверху прикрепить коллекцию. Иначе пустая секция будет перекрывать кнопку как футер")
        if kind == UICollectionView.elementKindSectionFooter {
            guard let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: CustomElement.collectionFooter.rawValue,
                for: indexPath
            ) as? AddHabitFooterCollectionView else {
                fatalError("Failed to dequeue AddHabitFooterCollectionView")
            }
            footer.parentFooterViewController = self
            return footer
        }
#warning("Не отрисовывается background")
        if kind == CustomElement.outlineBackground.rawValue {
            guard let backgroundView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "OutlineBackgroundView",
                for: indexPath
            ) as? OutlineBackgroundView else {
                fatalError("Failed to dequeue OutlineBackgroundView")
            }
            return backgroundView
        }
        
        assertionFailure("Unexpected kind: \(kind)")
        return UICollectionReusableView()
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
