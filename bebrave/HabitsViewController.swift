//
//  HabitsViewController.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 14/2/2567 BE.
//

import UIKit

enum CustomElement: String {
    case collectionHeader
    case sectionFooter
    case outlineBackground
    case habitsCell
    case writeDiaryCell
}

class HabitsViewController: UICollectionViewController {
    
// MARK: - UI components
    
    let historyButton = UIButton()
    let calendarLabel = UILabel()
    
// MARK: — Init
    
    init() {
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
            let footer = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60)
                ),
                elementKind: CustomElement.sectionFooter.rawValue,
                alignment: .bottom,
                absoluteOffset: .init(x: 0, y: 24)
            )
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 0, leading: 12, bottom: 0, trailing: 12)
            section.interGroupSpacing = 8
            section.boundarySupplementaryItems = [footer]
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
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.boundarySupplementaryItems = [header]
        let layout = UICollectionViewCompositionalLayout(sectionProvider: provider, configuration: configuration)
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Lifecycle view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        customiseHistoryButton()
        customiseCalendarLabel()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: historyButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: calendarLabel)
        
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: CustomElement.collectionHeader.rawValue, withReuseIdentifier: CustomElement.collectionHeader.rawValue)
        
        collectionView.register(HabitsCell.self, forCellWithReuseIdentifier: CustomElement.habitsCell.rawValue)
        collectionView.register(DiaryWriteCell.self, forCellWithReuseIdentifier: CustomElement.writeDiaryCell.rawValue)
        collectionView.register(OutlineBackgroundView.self, forSupplementaryViewOfKind: CustomElement.outlineBackground.rawValue, withReuseIdentifier: CustomElement.outlineBackground.rawValue)
        
        collectionView.register(AddNewHabitView.self, forSupplementaryViewOfKind: CustomElement.sectionFooter.rawValue, withReuseIdentifier: CustomElement.sectionFooter.rawValue)
    }

// MARK: - Objc methods
    
    @objc private func historyButtonTapped() {
        let history = HistoryViewController()
        self.navigationController?.pushViewController(history, animated: true)
    }
}

// MARK: — UICollectionViewDelegate

extension HabitsViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let isWriteDiary = indexPath.row == 2
        let reuseIdentifier = isWriteDiary
            ? CustomElement.writeDiaryCell.rawValue
            : CustomElement.habitsCell.rawValue
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = .tintColor.withAlphaComponent(0.05)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let customElement = CustomElement(rawValue: kind)
        switch customElement {
        case .sectionFooter:
            if let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CustomElement.sectionFooter.rawValue, for: indexPath) as? AddNewHabitView {
                footer.backgroundColor = .orange.withAlphaComponent(0.05)
                footer.parentViewController = self
                return footer
            }
//            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CustomElement.sectionFooter.rawValue, for: indexPath)
//            footer.backgroundColor = .orange.withAlphaComponent(0.05)
//            return footer
        case .collectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CustomElement.collectionHeader.rawValue, for: indexPath)
            header.backgroundColor = .red.withAlphaComponent(0.05)
            return header
        case .outlineBackground:
            let outlineBackground = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CustomElement.outlineBackground.rawValue, for: indexPath)
            return outlineBackground
        case .none, .habitsCell, .writeDiaryCell:
            fatalError()
        }
        return UICollectionReusableView()
    }
}

// MARK: — Customise navigation's items

extension HabitsViewController {
    
    private func customiseHistoryButton() {
        historyButton.setTitle("История", for: .normal)
        historyButton.setTitleColor(.tintColor, for: .normal)
        historyButton.setImage(UIImage(named: "History"), for: .normal)
        historyButton.contentVerticalAlignment = .fill
        historyButton.contentHorizontalAlignment = .fill
        historyButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4)
        historyButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        historyButton.addTarget(self, action: #selector(historyButtonTapped), for: .touchUpInside)
    }
    
    private func customiseCalendarLabel() {
        calendarLabel.text = "Январь"
        calendarLabel.textColor = .black
        calendarLabel.font = .boldSystemFont(ofSize: 20)
       // calendarLabel.textAlignment = .left
    }
    
}

import SwiftUI

struct FlowProvider: PreviewProvider {
    static var previews: some View {
        ContainterView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainterView: UIViewControllerRepresentable {
        
        let tabBar = TabBarViewController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<FlowProvider.ContainterView>) -> TabBarViewController {
            return tabBar
        }
        
        func updateUIViewController(_ uiViewController: FlowProvider.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<FlowProvider.ContainterView>) {
            
        }
    }
}

