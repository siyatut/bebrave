//
//  HistoryViewController+ProgressLayout.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 16/1/2568 BE.
//

import UIKit

enum ProgressLayout {
    
    static func createLayout() -> UICollectionViewLayout {
        let provider: UICollectionViewCompositionalLayoutSectionProvider = { section, environment in
            
            // 1. Background для ячейки
            let background = NSCollectionLayoutSupplementaryItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                ),
                elementKind: CustomElement.outlineBackground.rawValue,
                containerAnchor: .init(edges: .all)
            )
            
            // 2. Элемент (ячейка)
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(100) // Увеличиваем для прогресса
                ),
                supplementaryItems: [background]
            )
            
            // 3. Группа
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(100) // Высота группы = высота ячейки
                ),
                subitems: [item]
            )
            
            // 4. Секция
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 0, leading: 12, bottom: 0, trailing: 12)
            section.interGroupSpacing = 8
            
            return section
        }
        
        // 5. Хедер для фильтрации
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(100) // Высота хедера
            ),
            elementKind: CustomElement.collectionHeader.rawValue,
            alignment: .top,
            absoluteOffset: .init(x: 0, y: -24)
        )
        header.extendsBoundary = true
        header.contentInsets = .init(top: 0, leading: 12, bottom: 0, trailing: 12)
        
        // 6. Конфигурация
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.boundarySupplementaryItems = [header]
        
        return UICollectionViewCompositionalLayout(sectionProvider: provider, configuration: configuration)
    }
}
