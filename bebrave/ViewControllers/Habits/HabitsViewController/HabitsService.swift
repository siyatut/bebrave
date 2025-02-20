//
//  HabitsService.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 18/2/2568 BE.
//

import Foundation

class HabitService {

    private let storage = UserDefaultsManager.shared

    func getAllHabits() -> [Habit] {
        return storage.loadHabits()
    }

    func addHabit(_ habit: Habit) {
        storage.addHabit(habit)
    }

    func updateHabit(_ habit: Habit) {
        storage.updateHabit(habit)
    }

    func deleteHabit(id: UUID) {
        storage.deleteHabit(id: id)
    }

    func resetUncompletedHabits() {
        storage.resetUncompletedHabits()
    }
}
