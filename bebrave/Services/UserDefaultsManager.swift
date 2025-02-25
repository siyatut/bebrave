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

    // MARK: - Habit methods

    func loadHabits() -> [Habit] {
        guard let data = defaults.data(forKey: UserDefaultsKeys.habits) else {
            return []
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([Habit].self, from: data)
        } catch {
            logError("Ошибка при загрузке привычек", error: error)
            return []
        }
    }

    func saveHabits(_ habits: [Habit]) {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(habits)
            defaults.set(encodedData, forKey: UserDefaultsKeys.habits)
        } catch {
            handleSaveError(error, forKey: UserDefaultsKeys.habits)
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

    // MARK: - Period methods

    func loadSelectedPeriod() -> Period? {
        guard let data = defaults.data(forKey: UserDefaultsKeys.selectedPeriod) else {
            return nil
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Period.self, from: data)
        } catch {
            handleLoadError(error, forKey: UserDefaultsKeys.selectedPeriod)
            return nil
        }
    }

    func saveSelectedPeriod(_ period: Period) {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(period)
            defaults.set(encodedData, forKey: UserDefaultsKeys.selectedPeriod)
        } catch {
            handleSaveError(error, forKey: UserDefaultsKeys.selectedPeriod)
        }
    }

    // MARK: - Error Handling

    private func handleLoadError(_ error: Error, forKey key: String) {
        #if DEBUG
        assertionFailure("Ошибка при загрузке данных (\(key)): \(error)")
        #else
        logError("Ошибка при загрузке данных (\(key))", error: error)
        #endif
    }

    private func handleSaveError(_ error: Error, forKey key: String) {
        #if DEBUG
        assertionFailure("Ошибка при сохранении данных (\(key)): \(error)")
        #else
        logError("Ошибка при сохранении данных (\(key))", error: error)
        #endif
    }

    private func logError(_ message: String, error: Error) {
        print("\(message): \(error)")

    }
}
