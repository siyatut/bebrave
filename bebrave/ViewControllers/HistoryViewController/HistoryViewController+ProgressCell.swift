//
//  HistoryViewController+ProgressCell.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 16/1/2568 BE.
//

import UIKit

final class ProgressCell: UICollectionViewCell {
    
    static let identifier = "ProgressCell"
    
    // MARK: - UI Components
    
    private let habitNameLabel = UILabel()
    private let progressLabel = UILabel()
    private let progressBar = UIProgressView()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        habitNameLabel.font = AppStyle.Fonts.boldFont(size: 16)
        progressLabel.font = AppStyle.Fonts.regularFont(size: 16)
        progressLabel.textAlignment = .right
        progressBar.progressTintColor = AppStyle.Colors.isProgressHabitColor
        progressBar.trackTintColor = AppStyle.Colors.isUncompletedHabitColor
        progressBar.layer.cornerRadius = AppStyle.Sizes.cornerRadius
        progressBar.clipsToBounds = true
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        let headerStackView = UIStackView(arrangedSubviews: [habitNameLabel, progressLabel])
        headerStackView.axis = .horizontal
        headerStackView.distribution = .fillProportionally
    
        let stackView = UIStackView(arrangedSubviews: [headerStackView, progressBar])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            progressBar.heightAnchor.constraint(equalToConstant: 15) 
        ])
    }
    // MARK: - Configure
    
    func configure(with habit: HabitProgress) {
        habitNameLabel.text = habit.name
        progressLabel.text = "\(habit.completedDays) / \(habit.totalDays)"
        progressBar.progress = Float(habit.completedDays) / Float(habit.totalDays)
    }
    
    private func calculateProgress(for habit: Habit) -> Float {
        let totalFrequency = habit.frequency
        let completed = habit.progress.values.reduce(0, +)
        return totalFrequency > 0 ? Float(completed) / Float(totalFrequency) : 0.0
    }
}
