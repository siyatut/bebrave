//
//  HistoryViewController+DataSource.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 29/1/2568 BE.
//

import UIKit

extension HistoryViewController: UICollectionViewDataSource {
    
    // MARK: - Number of Items

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel.habitsProgress.count
    }
    
    // MARK: - Cell Configuration

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CustomElement.progressCell.rawValue,
            for: indexPath
        ) as? ProgressCell else {
            let error = CellError.dequeuingFailed(
                reuseIdentifier: CustomElement.progressCell.rawValue
            )
            fatalError("\(error)")
        }
        let habitProgress = viewModel.habitsProgress[indexPath.row]
        cell.configure(with: habitProgress)
        return cell
    }
    
    // MARK: - Supplementary Views

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
        case CustomElement.historyHeader.rawValue:
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: CustomElement.historyHeader.rawValue,
                for: indexPath
            ) as? HistoryHeaderView else {
                fatalError("Не удалось deque header с типом \(kind)")
            }
            header.configure(with: viewModel, onPeriodChange: { [weak self] selectedPeriod in
                   self?.viewModel.updateSelectedPeriod(selectedPeriod)
               })
            return header

        case CustomElement.outlineBackground.rawValue:
            guard let background = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: CustomElement.outlineBackground.rawValue,
                for: indexPath
            ) as? OutlineBackgroundView else {
                let error = SupplementaryViewError.dequeuingFailed(
                    kind: kind,
                    reuseIdentifier: CustomElement.outlineBackground.rawValue
                )
                fatalError("\(error)")
            }
            return background

        default:
            fatalError("\(SupplementaryViewError.unexpectedKind(kind))")
        }
    }
}
