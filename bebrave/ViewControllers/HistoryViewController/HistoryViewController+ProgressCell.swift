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
    private let progressBar = UIProgressView(progressViewStyle: .bar)
    
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
        habitNameLabel.font = .boldSystemFont(ofSize: 16)
        habitNameLabel.textColor = .label
        
        progressLabel.font = .systemFont(ofSize: 14)
        progressLabel.textColor = .secondaryLabel
        
        progressBar.progressTintColor = .systemGreen
        progressBar.trackTintColor = .systemGray5
        
        // Stack View
        let stack = UIStackView(arrangedSubviews: [habitNameLabel, progressBar, progressLabel])
        stack.axis = .vertical
        stack.spacing = 4
        contentView.addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Configure
    func configure(with habit: HabitProgress) {
        habitNameLabel.text = habit.name
        progressLabel.text = "\(habit.completedDays) / \(habit.totalDays)"
        progressBar.progress = Float(habit.completedDays) / Float(habit.totalDays)
    }
}
