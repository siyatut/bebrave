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
    
    private var daysData: [(date: Date, emoji: String)] = []
    
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
            
            var totalProgress = 0
            var totalFrequency = 0
            var skippedCount = 0
            
            for habit in habits {
                let status = habit.getStatus(for: startOfDay)
                switch status {
                case .completed:
                    totalProgress += habit.frequency
                    totalFrequency += habit.frequency
                case .partiallyCompleted(let progress, let total):
                    totalProgress += progress
                    totalFrequency += total
                case .skipped:
                    skippedCount += 1
                case .notCompleted:
                    totalFrequency += habit.frequency
                }
            }
            
            if skippedCount == habits.count && habits.count > 0 {
                return (date: startOfDay, emoji: "💤")
            }
            
            let completionRate = totalFrequency > 0 ? (totalProgress * 100) / totalFrequency : 0
            
            let emoji: String
            switch completionRate {
            case 80...100:
                emoji = "🎉" // Отлично
            case 50..<80:
                emoji = "🙂" // Хорошо
            case 20..<50:
                emoji = "😕" // Так себе
            default:
                emoji = "😞" // Плохо
            }
            
            return (date: startOfDay, emoji: emoji)
        }
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension HeaderDaysCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as! DayCell
        let item = daysData[indexPath.item]
        
        let calendar = Calendar.current
        let isCurrentDay = calendar.isDate(item.date, inSameDayAs: Date())
        
        cell.configure(date: item.date, emoji: item.emoji, isCurrentDay: isCurrentDay)
        return cell
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

// MARK: - DayCell

private class DayCell: UICollectionViewCell {
    
    // MARK: - UI components of cell
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = AppStyle.Fonts.regularFont(size: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = AppStyle.Fonts.regularFont(size: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup methods
    
    private func setupLayout() {
        contentView.addSubview(dayLabel)
        contentView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            dayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            emojiLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 3),
            emojiLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.heightAnchor.constraint(equalToConstant: 20),
            emojiLabel.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupLayer() {
        contentView.layer.cornerRadius = AppStyle.Sizes.cornerRadius
        contentView.layer.borderWidth = AppStyle.Sizes.borderWidth
        contentView.layer.borderColor = AppStyle.Colors.borderColor.cgColor
        contentView.layer.masksToBounds = true
    }
    
    func configure(date: Date, emoji: String, isCurrentDay: Bool) {
        let calendar = Calendar.current
        let isFutureDay = date > calendar.startOfDay(for: Date())
        
        dayLabel.text = dateFormatter.string(from: date)
        
        
        if isCurrentDay {
            contentView.backgroundColor = AppStyle.Colors.primaryColor
            dayLabel.textColor = .white
            emojiLabel.text = emoji
            emojiLabel.textColor = .white
            emojiLabel.backgroundColor = .clear
        } else if isFutureDay {
            contentView.backgroundColor = .clear
            dayLabel.textColor = AppStyle.Colors.textColor
            emojiLabel.text = nil
            emojiLabel.backgroundColor = AppStyle.Colors.backgroundEmptyStateColor
            emojiLabel.layer.cornerRadius = 10
            emojiLabel.layer.masksToBounds = true
            emojiLabel.layer.borderColor = UIColor.clear.cgColor
        } else {
            contentView.backgroundColor = .clear
            dayLabel.textColor = AppStyle.Colors.textColor
            emojiLabel.text = emoji
            emojiLabel.textColor = AppStyle.Colors.textColor
            emojiLabel.backgroundColor = .clear
        }
    }
}

// MARK: - Public Methods

extension HeaderDaysCollectionView {
    func getDisplayedDates() -> [Date] {
        return daysData.map { $0.date }
    }
}
