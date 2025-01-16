//
//  HistoryViewConroller.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 28/2/2567 BE.
//

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
        title = "История"
        navigationController?.navigationBar.tintColor = AppStyle.Colors.secondaryColor
        setupCollectionView()
        calculateProgress()
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: ProgressLayout.createLayout())
        collectionView.dataSource = self
        collectionView.register(ProgressCell.self, forCellWithReuseIdentifier: ProgressCell.identifier)
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
}

extension HistoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return habitsProgress.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCell.identifier, for: indexPath) as! ProgressCell
        cell.configure(with: habitsProgress[indexPath.item])
        return cell
    }
}

