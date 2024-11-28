//
//  HeaderDaysCollectionView.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 27/11/2567 BE.
//

import UIKit

#warning("Добавила логику для отображения календарных дней, но не вынесла её в основной контроллер")

class HeaderDaysCollectionView: UICollectionReusableView {
    
    weak var parentHeaderViewController: UIViewController?
    
    // MARK: - UI Components
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var daysData: [(date: Date, emoji: String)] = []
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        setupLayout()
        generateDaysForCurrentMonth()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
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
    
    // MARK: - Data Methods
    
    private func generateDaysForCurrentMonth() {
        let calendar = Calendar.current
        let today = Date()
        
        guard let monthRange = calendar.range(of: .day, in: .month, for: today),
              let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today))
        else {
            assertionFailure("Unable to calculate the range of days in the current month")
            return
        }
        
        daysData = monthRange.compactMap { day -> (date: Date, emoji: String)? in
            let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
            assert(date != nil, "Не удалось создать дату для дня \(day)")
            let emoji = "😌"
            if let date = date {
                return (date: date, emoji: emoji)
            }
            return nil
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
        cell.configure(date: item.date, emoji: item.emoji)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HeaderDaysCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 70)
    }
}

// MARK: - DayCell

private class DayCell: UICollectionViewCell {
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(dayLabel)
        contentView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            dayLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 4),
            dayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    func configure(date: Date, emoji: String) {
        dayLabel.text = dateFormatter.string(from: date)
        emojiLabel.text = emoji
    }
    
}
