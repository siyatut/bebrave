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
    var monthFrequency: Int
    var daysOfWeek: [Bool]
    var progress: [Date: Int]
    var skipDates: Set<Date>
}

// MARK: - Habit Factory

extension Habit {
    static func createNew(
        title: String,
        frequency: Int,
        monthFrequency: Int,
        daysOfWeek: [Bool] = []
    ) -> Habit {
        return Habit(
            id: UUID(),
            title: title,
            frequency: frequency,
            monthFrequency: monthFrequency,
            daysOfWeek: daysOfWeek,
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
    
    func calculateYearProgress(for year: Int, calendar: Calendar = .current) -> (completedDays: Int, totalDays: Int) {
        let yearStart = calendar.date(from: DateComponents(year: year, month: 1, day: 1))!
        let yearEnd = calendar.date(from: DateComponents(year: year + 1, month: 1, day: 1))!
        
        let totalDays = calendar.dateComponents([.day], from: yearStart, to: yearEnd).day!
        let completedDays = progress.keys.filter { calendar.isDate($0, equalTo: yearStart, toGranularity: .year) }.count
        
        return (completedDays, totalDays)
    }
}


