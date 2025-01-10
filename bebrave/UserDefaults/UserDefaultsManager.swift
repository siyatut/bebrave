//
//  UserDefaultsManager.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 3/12/2567 BE.
//

// TODO: - Разделить на разные файлы


import UIKit

enum HabitStatus {
    case notCompleted
    case partiallyCompleted(progress: Int, total: Int)
    case completed
    case skipped
}

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

// MARK: - UserDefaults Keys

enum UserDefaultsKeys {
    static let habits = "user_habits_key"
}

// MARK: - UserDefaults Manager

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
   
    private init() {}
    
    // MARK: - Keys
    
    private enum Keys {
        static let habits = "user_habits_key"
    }
    
    // MARK: - Public Methods
    
    func resetUncompletedHabits() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        
        var habits = loadHabits()
        for index in habits.indices {
            // Проверяю: привычка была пропущена или выполнена вчера?
            if habits[index].progress.keys.contains(yesterday) ||
                habits[index].skipDates.contains(yesterday) {
                continue // Пропускаю сброс для привычек, с которыми был контакт
            }
            
            // Если взаимодействия за вчера не было, сбрасываю прогресс
            habits[index].progress[yesterday] = 0
        }
        saveHabits(habits)
    }
    
    func saveHabits(_ habits: [Habit]) {
        do {
            let encodedData = try JSONEncoder().encode(habits)
            defaults.set(encodedData, forKey: Keys.habits)
        } catch {
            assertionFailure("Ошибка при сохранении привычек: \(error)")
        }
    }
    
    func loadHabits() -> [Habit] {
        guard let data = defaults.data(forKey: Keys.habits) else {
            return []
        }
        do {
            return try JSONDecoder().decode([Habit].self, from: data)
        } catch {
            print("Ошибка при загрузке привычек: \(error)")
            return []
        }
    }
    
    func addHabit(_ habit: Habit) {
        var habits = loadHabits()
        habits.append(habit)
        saveHabits(habits)
    }
    
    func updateHabit(_ updatedHabit: Habit) {
        var habits = loadHabits()
        if let index = habits.firstIndex(where: { $0.id == updatedHabit.id }) {
            habits[index] = updatedHabit
            saveHabits(habits)
        }
    }
    
    func deleteHabit(id: UUID) {
        var habits = loadHabits()
        habits.removeAll { $0.id == id }
        saveHabits(habits)
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


