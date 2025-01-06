//
//  UserDefaultsManager.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 3/12/2567 BE.
//


import Foundation

// MARK: - Habit Model

struct Habit: Codable {
    let id: UUID
    var title: String
    var frequency: Int
    var progress: [Date: Int]
}

// MARK: - Habit Factory

extension Habit {
    static func createNew(title: String, frequency: Int) -> Habit {
        return Habit(
            id: UUID(),
            title: title,
            frequency: frequency,
            progress: [:]
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

extension UserDefaultsManager {
    func resetUncompletedHabits() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        var habits = loadHabits()
        for index in habits.indices {
            // Если привычка не обновлена сегодня, сбросить её прогресс
            if let lastProgressDate = habits[index].progress.keys.max(),
               !calendar.isDate(lastProgressDate, inSameDayAs: today) {
                habits[index].progress[today] = 0 // Условно "невыполнено"
            }
        }
        saveHabits(habits)
    }
}

extension Habit {
    /// Проверяет, выполнена ли привычка за сегодня
    func isCompletedToday() -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return progress.keys.contains { calendar.isDate($0, inSameDayAs: today) }
    }
    
    /// Отмечает привычку как выполненную
    mutating func markCompleted() {
        let today = Calendar.current.startOfDay(for: Date())
        progress[today] = (progress[today] ?? 0) + 1
    }
    
    /// Пропускает текущий день
    mutating func skipToday() {
        let today = Calendar.current.startOfDay(for: Date())
        progress[today] = -1 // Условный "пропуск"
    }
    
    /// Сбрасывает выполнение привычки за сегодня
    mutating func resetToday() {
        let today = Calendar.current.startOfDay(for: Date())
        progress[today] = nil
    }
}

extension UserDefaultsManager {
    func updateProgress(for habitID: UUID, date: Date, value: Int) {
        var habits = loadHabits()
        if let index = habits.firstIndex(where: { $0.id == habitID }) {
            habits[index].progress[date] = value
            saveHabits(habits)
        }
    }
}

