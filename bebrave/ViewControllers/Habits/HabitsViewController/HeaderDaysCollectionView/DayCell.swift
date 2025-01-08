//
//  DayCell.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 8/1/2568 BE.
//

import UIKit

class DayCell: UICollectionViewCell {
    
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
