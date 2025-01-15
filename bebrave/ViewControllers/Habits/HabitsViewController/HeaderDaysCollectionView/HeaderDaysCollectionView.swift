//
//  HeaderDaysCollectionView.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 27/11/2567 BE.
//

import UIKit

class HeaderDaysCollectionView: UICollectionReusableView {
    
    // MARK: - UI components
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        layout.sectionInset = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var daysData: [(date: Date, emoji: String)] = []
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        setupLayout()
        generateDaysForCurrentMonth()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Setup methods
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DayCell.self, forCellWithReuseIdentifier: "DayCell")
        collectionView.backgroundColor = .clear
        addSubview(collectionView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Data methods
    
    private func generateDaysForCurrentMonth() {
        var calendar = Calendar.current
        let today = Date()
        
        calendar.firstWeekday = 2
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) else {
            assertionFailure("Не удалось определить начало недели")
            return
        }
        
        let habits = UserDefaultsManager.shared.loadHabits()
        
        daysData = (0..<7).compactMap { dayOffset -> (date: Date, emoji: String)? in
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek) else { return nil }
            let startOfDay = calendar.startOfDay(for: date)
            let emoji = HabitEmojiCalculator.calculateEmoji(for: startOfDay, habits: habits, calendar: calendar)
            return (date: startOfDay, emoji: emoji)
        }
        collectionView.reloadData()
    }
    
    func getDisplayedDates() -> [Date] {
        return daysData.map { $0.date }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HeaderDaysCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing = 6 * 4
        let availableWidth = collectionView.bounds.width - CGFloat(totalSpacing)
        let itemWidth = floor(availableWidth / 7)
        return CGSize(width: itemWidth, height: 70)
    }
}
