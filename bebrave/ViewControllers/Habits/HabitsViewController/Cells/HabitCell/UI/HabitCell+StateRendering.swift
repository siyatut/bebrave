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

    func applyHabitState(_ habit: Habit) {
        resetCellState()

        let today = Calendar.current.startOfDay(for: Date())
        let status = habit.getStatus(for: today)

        switch status {
        case .skipped:
            currentProgress = 0
            updateHabitProgress()
            applySkippedHabitPattern(for: status)

        case .partiallyCompleted(let progress, _):
            currentProgress = progress
            updateHabitProgress()

        case .completed:
            currentProgress = habit.frequency
            updateHabitProgress()

        case .notCompleted:
            currentProgress = 0
            updateHabitProgress()
            let isToday = Calendar.current.isDateInToday(today)
            contentContainer.backgroundColor = isToday
                ? AppStyle.Colors.backgroundColor
                : AppStyle.Colors.isUncompletedHabitColor
        }
    }

    func configure(with habit: Habit, viewModel: HabitsViewModel) {
        self.habit = habit
        self.viewModel = viewModel
        habitsName.text = habit.title
        applyHabitState(habit)
    }

    func resetCellState() {
        clearCheckmark()
        clearLayerPatterns()
        currentProgress = 0
        contentContainer.backgroundColor = AppStyle.Colors.backgroundColor
    }
}
