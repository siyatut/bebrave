//
//  HabitsLayout.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 23/12/2567 BE.
//

import UIKit

enum HabitsLayout {
    
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
            absoluteOffset: .init(x: 0, y: 300)
        )
        footer.extendsBoundary = true
        footer.contentInsets = .init(top: 0, leading: 12, bottom: 0, trailing: 12)
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.boundarySupplementaryItems = [header, footer]
        return UICollectionViewCompositionalLayout(sectionProvider: provider, configuration: configuration)
    }
}
