//
//  Habit.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 14/1/2568 BE.
//

import Foundation

// MARK: - Habit Model

struct Habit: Codable {
    let id: UUID
    var title: String
    var frequency: Int
    var progress: [Date: Int]
    var skipDates: Set<Date>
}

// MARK: - Habit Factory

extension Habit {
    static func createNew(title: String, frequency: Int) -> Habit {
        return Habit(
            id: UUID(),
            title: title,
            frequency: frequency,
            progress: [:],
            skipDates: []
        )
    }
}

// MARK: - Habit progress management

extension Habit {
    
    mutating func markCompleted() {
        let today = Calendar.current.startOfDay(for: Date())
        let currentProgress = progress[today] ?? 0
        if currentProgress < frequency {
            progress[today] = currentProgress + 1
        }
    }
    
    mutating func undoCompletion() {
        let today = Calendar.current.startOfDay(for: Date())
        let currentProgress = progress[today] ?? 0
        if currentProgress > 0 {
            progress[today] = currentProgress - 1
        }
    }
    
    mutating func skipToday() {
        let today = Calendar.current.startOfDay(for: Date())
        skipDates.insert(today)
    }
    
    mutating func undoSkip() {
        let today = Calendar.current.startOfDay(for: Date())
        skipDates.remove(today)
        progress[today] = 0
    }
    
    func getStatus(for date: Date = Date()) -> HabitStatus {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        
        if skipDates.contains(startOfDay) {
            return .skipped
        }
        
        let progressForDay = progress[startOfDay] ?? 0
        
        if progressForDay == 0 {
            return .notCompleted
        } else if progressForDay < frequency {
            return .partiallyCompleted(progress: progressForDay, total: frequency)
        } else {
            return .completed
        }
    }
}


