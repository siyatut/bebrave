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
    var creationDate: Date
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
            skipDates: [],
            creationDate: Date()
        )
    }
}

// MARK: - Habit progress management

extension Habit {

    mutating func markCompleted(calendar: Calendar = .current) {
        let today = calendar.startOfDay(for: Date())
        let currentProgress = progress[today] ?? 0
        if currentProgress < frequency {
            progress[today] = currentProgress + 1
        }
    }

    mutating func undoCompletion(calendar: Calendar = .current) {
        let today = calendar.startOfDay(for: Date())
        let currentProgress = progress[today] ?? 0
        if currentProgress > 0 {
            progress[today] = currentProgress - 1
        }
    }

    mutating func skipToday(calendar: Calendar = .current) {
        let today = calendar.startOfDay(for: Date())
        skipDates.insert(today)
    }

    mutating func undoSkip(calendar: Calendar = .current) {
        let today = calendar.startOfDay(for: Date())
        skipDates.remove(today)
        progress[today] = 0
    }

    mutating func updateSkippedDays(startDate: Date = Date(), endDate: Date = Date()) {
        let calendar = Calendar.current
        var currentDate = calendar.startOfDay(for: startDate)
        let endOfDay = calendar.startOfDay(for: endDate)

        while currentDate <= endOfDay {
            let weekday = (calendar.component(.weekday, from: currentDate) + 5) % 7
            let startOfDay = calendar.startOfDay(for: currentDate)

            // Если день недели не отмечен, но день уже пропущен вручную, не перезаписываю его
            if !daysOfWeek[weekday] && !skipDates.contains(startOfDay) {
                skipDates.insert(startOfDay)
            }

            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
    }

    func getStatus(for date: Date = Date(), calendar: Calendar = .current) -> HabitStatus {
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

    func calculateProgress(
        from startDate: Date,
        to endDate: Date,
        calendar: Calendar = .current
    ) -> (completedDays: Int, totalDays: Int) {
        guard startDate <= endDate else { return (0, 0) }

        let totalDays = calendar.dateComponents([.day], from: startDate, to: endDate).day ?? 0 + 1

        let completedDays = progress.keys.filter {
            $0 >= startDate && $0 <= endDate
        }.count

        return (completedDays, totalDays)
    }
}
