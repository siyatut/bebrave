//
//  HabitsViewController.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 14/2/2567 BE.
//

import UIKit

class HabitsViewController: UICollectionViewController {
    
// MARK: - UI components
    
    let historyButton = UIButton()
    let calendarLabel = UILabel()
    
// MARK: — Init
    
    init() {
        let provider: UICollectionViewCompositionalLayoutSectionProvider = { section, environment in
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60)
                )
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
                elementKind: "Button",
                alignment: .bottom,
                absoluteOffset: .init(x: 0, y: 24)
            )
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 0, leading: 12, bottom: 0, trailing: 12)
            section.interGroupSpacing = 8
            section.boundarySupplementaryItems = [footer]
            return section
        }
        let layout = UICollectionViewCompositionalLayout(sectionProvider: provider)
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
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: "Button", withReuseIdentifier: "Button")
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .tintColor
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Button", for: indexPath)
        footer.backgroundColor = .orange
        return footer
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

