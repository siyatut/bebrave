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
    
    private let habitNameLabel = UILabel.styled(
        text: ""
    )
    private let progressLabel = UILabel.styled(
        text: "",
        fontSize: 14,
        color: AppStyle.Colors.textColorSecondary,
        alignment: .right
    )
    private let segmentedProgressBar = SegmentedProgressBar()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProgressCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupProgressCell() {
        segmentedProgressBar.layer.cornerRadius = 5
        segmentedProgressBar.layer.masksToBounds = true
        segmentedProgressBar.translatesAutoresizingMaskIntoConstraints = false
        
        let headerStackView = UIStackView(arrangedSubviews: [habitNameLabel, progressLabel])
        headerStackView.axis = .horizontal
        headerStackView.distribution = .fillProportionally
        
        let stackView = UIStackView(arrangedSubviews: [headerStackView, segmentedProgressBar])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            segmentedProgressBar.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    // MARK: - Configure
    
    func configure(with habitProgress: HabitProgress) {
        habitNameLabel.text = habitProgress.name
        progressLabel.text = "\(habitProgress.completedDays) / \(habitProgress.totalDays)"
        
        let segmentRatios: [(color: UIColor, ratio: CGFloat)] = [
            (AppStyle.Colors.isProgressHabitColor,
             CGFloat(habitProgress.completedDays) /
             CGFloat(habitProgress.totalDays)
            ),
            (AppStyle.Colors.isProgressHabitColor,
             CGFloat(habitProgress.skippedDays) /
             CGFloat(habitProgress.totalDays)
            ),
            (AppStyle.Colors.isUncompletedHabitColor,
             CGFloat(habitProgress.remainingDays) /
             CGFloat(habitProgress.totalDays)
            )
        ]
        
        segmentedProgressBar.setSegments(segmentRatios)
    }
    
    private func calculateProgress(for habit: Habit) -> Float {
        let totalFrequency = habit.frequency
        let completed = habit.progress.values.reduce(0, +)
        return totalFrequency > 0 ? Float(completed) / Float(totalFrequency) : 0.0
    }
}
