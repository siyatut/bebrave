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
    var isSkipped: Bool = false
}

// MARK: - Habit Factory

extension Habit {
    static func createNew(title: String, frequency: Int) -> Habit {
        return Habit(
            id: UUID(),
            title: title,
            frequency: frequency,
            progress: [:],
            isSkipped: false
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
