//
//  HabitsViewController+CollectionView.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 3/1/2568 BE.
//

import UIKit

extension HabitsViewController {
    
    func setupCollectionView() {
        let layout = HabitsLayout.createLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(
            HabitsCell.self,
            forCellWithReuseIdentifier: CustomElement.habitsCell.rawValue
        )
        collectionView.register(
            DiaryWriteCell.self,
            forCellWithReuseIdentifier: CustomElement.writeDiaryCell.rawValue
        )
        collectionView.register(
            OutlineBackgroundView.self,
            forSupplementaryViewOfKind: CustomElement.outlineBackground.rawValue,
            withReuseIdentifier: CustomElement.outlineBackground.rawValue
        )
        collectionView.register(
            HeaderDaysCollectionView.self,
            forSupplementaryViewOfKind: CustomElement.collectionHeader.rawValue,
            withReuseIdentifier: CustomElement.collectionHeader.rawValue
        )
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: addNewHabitButton.topAnchor, constant: -12)
        ])
    }
}
