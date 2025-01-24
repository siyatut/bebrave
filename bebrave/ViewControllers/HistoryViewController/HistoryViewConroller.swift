//
//  HistoryViewConroller.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 28/2/2567 BE.
//

#warning("№2: Если привычек нет, в истории пусто. Нужно тоже заглушку какую-то добавить. Возможно, переиспользовать серое вью?")

import UIKit

class HistoryViewController: UIViewController {
    
    // MARK: - UI Components
    
    private var collectionView: UICollectionView!
    
    // MARK: - Data
    
    private var habits: [Habit] = []
    private var habitsProgress: [HabitProgress] = []
    
    // MARK: - Init
    
    init(habits: [Habit]) {
        self.habits = habits
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppStyle.Colors.backgroundColor
        navigationController?.navigationBar.tintColor = AppStyle.Colors.secondaryColor
        setupCollectionView()
        calculateProgress()
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: ProgressLayout.createLayout())
        collectionView.dataSource = self
        
        collectionView.register(
            ProgressCell.self,
            forCellWithReuseIdentifier: CustomElement.progressCell.rawValue
        )
        
        collectionView.register(
            HistoryHeaderView.self,
            forSupplementaryViewOfKind: CustomElement.historyHeader.rawValue,
            withReuseIdentifier: CustomElement.historyHeader.rawValue
        )
        
        collectionView.register(
            OutlineBackgroundView.self,
            forSupplementaryViewOfKind: CustomElement.outlineBackground.rawValue,
            withReuseIdentifier: CustomElement.outlineBackground.rawValue
        )
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Data Handling
    
    private func calculateProgress() {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        
        habitsProgress = habits.map { habit in
            let (completedDays, totalDays) = habit.calculateYearProgress(for: currentYear, calendar: calendar)
            return HabitProgress(name: habit.title, completedDays: completedDays, totalDays: totalDays)
        }
        
        collectionView.reloadData()
    }
    
    private func updateData(for period: Period) {
        switch period {
        case .week:
            print("Показать данные за неделю")
        case .month:
            print("Показать данные за месяц")
        case .halfYear:
            print("Показать данные за полгода")
        case .year:
            print("Показать данные за год")
        }
        
        calculateProgress()
        collectionView.reloadData()
    }
}

extension HistoryViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return habitsProgress.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CustomElement.progressCell.rawValue,
            for: indexPath
        ) as? ProgressCell else {
            fatalError("\(CellError.dequeuingFailed(reuseIdentifier: CustomElement.progressCell.rawValue))")
        }
        
        let habitProgress = habitsProgress[indexPath.row]
        cell.configure(with: habitProgress)
        return cell
    }
    
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
            
            header.configure(
                onPeriodChange: { [weak self] selectedPeriod in
                    self?.updateData(for: selectedPeriod)
                }
            )
            return header
            
        case CustomElement.outlineBackground.rawValue:
            guard let background = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: CustomElement.outlineBackground.rawValue,
                for: indexPath
            ) as? OutlineBackgroundView else {
                fatalError("\(SupplementaryViewError.dequeuingFailed(kind: kind, reuseIdentifier: CustomElement.outlineBackground.rawValue))")
            }
            return background
            
        default:
            fatalError("\(SupplementaryViewError.unexpectedKind(kind))")
        }
    }
    
}

