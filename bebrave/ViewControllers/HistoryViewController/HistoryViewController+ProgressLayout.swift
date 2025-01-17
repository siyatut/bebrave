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
                heightDimension: .absolute(40)
            ),
            elementKind: CustomElement.historyHeader.rawValue,
            alignment: .top
        )
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.boundarySupplementaryItems = [header]
        return UICollectionViewCompositionalLayout(sectionProvider: provider, configuration: configuration)
    }
}
