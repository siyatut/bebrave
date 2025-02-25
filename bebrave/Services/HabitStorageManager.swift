//
//  HabitStorageManager.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 25/2/2568 BE.
//

import UIKit

final class HabitStorageManager {

    private let defaults = UserDefaults.standard

    // MARK: - Public Methods

    func loadHabits() -> [Habit] {
        guard let data = defaults.data(forKey: UserDefaultsKeys.habits) else {
            return []
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([Habit].self, from: data)
        } catch {
            StorageErrorLogger.handleLoadError(error, forKey: UserDefaultsKeys.habits)
            return []
        }
    }

    func saveHabits(_ habits: [Habit]) {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(habits)
            defaults.set(encodedData, forKey: UserDefaultsKeys.habits)
        } catch {
            StorageErrorLogger.handleSaveError(error, forKey: UserDefaultsKeys.habits)
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
}
