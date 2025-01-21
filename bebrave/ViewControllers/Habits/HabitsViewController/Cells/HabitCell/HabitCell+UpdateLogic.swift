//
//  HabitCell+UpdateLogic.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 14/1/2568 BE.
//

import UIKit

extension HabitCell {
    
    func updateHabitProgress() {
        guard let habit = habit else { return }
        
        let totalWidth = contentView.bounds.width
        let percentage = CGFloat(currentProgress) / CGFloat(habit.frequency)
        let newWidth = totalWidth * percentage
        
        habitsCount.text = "\(currentProgress) из \(habit.frequency)"
        percentDone.text = "\(Int(percentage * 100))%"
        
        progressViewWidthConstraint.constant = newWidth
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut]) {
            self.contentView.layoutIfNeeded()
        }
        
        if percentage >= 1.0 {
            drawCheckmark()
        } else {
            clearCheckmark()
        }
    }
    
    func configure(with habit: Habit) {
        self.habit = habit
        resetCellState()
        
        let today = Calendar.current.startOfDay(for: Date())
        let status = habit.getStatus(for: today)
        
        switch status {
        case .notCompleted:
            contentContainer.backgroundColor = Calendar.current.isDateInToday(today) ?
            AppStyle.Colors.backgroundColor : AppStyle.Colors.isUncompletedHabitColor
        case .partiallyCompleted(let progress, _):
            currentProgress = progress
            updateHabitProgress()
        case .completed:
            currentProgress = habit.frequency
            drawCheckmark()
        case .skipped:
            applySkippedHabitPattern(for: status)
        }
        
        habitsName.text = habit.title
    }
    
    func resetCellState() {
        clearCheckmark()
        clearLayerPatterns()
        currentProgress = 0
        contentContainer.backgroundColor = AppStyle.Colors.backgroundColor
    }
}
