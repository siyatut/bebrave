//
//  HeaderDays+DataSourceDelegata.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 8/1/2568 BE.
//

import UIKit

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension HeaderDaysCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return daysData.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        do {
            let cell: DayCell = try collectionView.dequeueCell(
                withReuseIdentifier: "DayCell",
                for: indexPath
            )
            let item = daysData[indexPath.item]
            
            let calendar = Calendar.current
            let isCurrentDay = calendar.isDate(item.date, inSameDayAs: Date())
            
            cell.configure(date: item.date, emoji: item.emoji, isCurrentDay: isCurrentDay)
            return cell
        } catch {
            assertionFailure("Error dequeuing DayCell: \(error)")
            return UICollectionViewCell()
        }
    }
}
