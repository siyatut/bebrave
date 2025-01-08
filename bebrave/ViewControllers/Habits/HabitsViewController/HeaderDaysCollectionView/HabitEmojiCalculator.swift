//
//  HabitEmojiCalculator.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 8/1/2568 BE.
//

import Foundation

class HabitEmojiCalculator {
    static func calculateEmoji(for date: Date, habits: [Habit], calendar: Calendar) -> String {
        let startOfDay = calendar.startOfDay(for: date)
        
        var totalProgress = 0
        var totalFrequency = 0
        var skippedCount = 0
        
        // Скипнутые привычки не влияют на расчёт эмодзи. Думаю, это в целом логично
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
            return "💤"
        }
        
        let completionRate = totalFrequency > 0 ? (totalProgress * 100) / totalFrequency : 0
        
        switch completionRate {
        case 80...100:
            return "🎉" // Отлично
        case 50..<80:
            return "🙂" // Хорошо
        case 20..<50:
            return "😕" // Так себе
        default:
            return "😞" // Плохо
        }
    }
}
