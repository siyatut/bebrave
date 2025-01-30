//
//  HabitsViewController+CollectionViewDelegate.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 23/12/2567 BE.
//

import UIKit

// MARK: - UICollectionView DataSource

extension HabitsViewController {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return habits.count + 1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        do {
            if indexPath.item < habits.count {
                let habitCell: HabitCell = try collectionView.dequeueCell(
                    withReuseIdentifier: CustomElement.habitsCell.rawValue,
                    for: indexPath
                )
                let habit = habits[indexPath.item]
                habitCell.delegate = self
                habitCell.configure(with: habit)
                return habitCell
            } else if indexPath.item == habits.count {
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

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        do {
            guard let customElement = CustomElement(rawValue: kind) else {
                throw SupplementaryViewError.unexpectedKind(kind)
            }

            switch customElement {
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

// MARK: - UICollectionView Delegate

extension HabitsViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0, indexPath.item < habits.count {
            let selectedHabit = habits[indexPath.item]
            print("Selected habit: \(selectedHabit.title)")
        }
    }
}
