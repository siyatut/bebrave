//
//  UserDefaultsManager.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 3/12/2567 BE.
//

import Foundation

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

