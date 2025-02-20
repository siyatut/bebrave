//
//  HabitViewModel.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 18/2/2568 BE.
//

import Foundation
import Combine

class HabitsViewModel: ObservableObject {
    
    @Published private(set) var habits: [Habit] = []

    private let habitService = HabitService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        loadHabits()
    }

    func loadHabits() {
        habits = habitService.getAllHabits()
    }

    func addHabit(_ habit: Habit) {
        habitService.addHabit(habit)
        habits = habitService.getAllHabits()
    }

    func updateHabit(_ habit: Habit) {
        habitService.updateHabit(habit)
        habits = habitService.getAllHabits()
    }

    func deleteHabit(id: UUID) {
        habitService.deleteHabit(id: id)
        habits = habitService.getAllHabits()
    }

    func markHabitCompleted(id: UUID) {
        guard var habit = habits.first(where: { $0.id == id }) else { return }
        habit.markCompleted()
        updateHabit(habit)
    }

    func undoCompletion(id: UUID) {
        guard var habit = habits.first(where: { $0.id == id }) else { return }
        habit.undoCompletion()
        updateHabit(habit)
    }

    func skipHabit(id: UUID) {
        guard var habit = habits.first(where: { $0.id == id }) else { return }
        habit.skipToday()
        updateHabit(habit)
    }

    func undoSkipHabit(id: UUID) {
        guard var habit = habits.first(where: { $0.id == id }) else { return }
        habit.undoSkip()
        updateHabit(habit)
    }

    func resetUncompletedHabits() {
        habitService.resetUncompletedHabits()
        habits = habitService.getAllHabits()
    }
    
    func updateSkippedDaysForAllHabits() {
        for index in habits.indices {
            habits[index].updateSkippedDays(startDate: habits[index].creationDate, endDate: Date())
        }
    }
}
