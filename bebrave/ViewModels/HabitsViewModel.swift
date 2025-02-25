//
//  HabitViewModel.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 18/2/2568 BE.
//

import Foundation
import Combine

final class HabitsViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published private(set) var habits: [Habit] = []

    // MARK: - Private Properties

    private let habitService: HabitService
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(habitService: HabitService = HabitService()) {
        self.habitService = habitService
        loadHabits()
    }

    // MARK: - Public Methods

    func loadHabits() {
        habits = habitService.getAllHabits()
    }

    func addHabit(_ habit: Habit) {
        habitService.addHabit(habit)
        habits.append(habit)
    }

    func updateHabit(_ habit: Habit) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        habits[index] = habit
        habitService.updateHabit(habit)
    }

    func deleteHabit(id: UUID) {
        guard let index = habits.firstIndex(where: { $0.id == id }) else { return }
        habits.remove(at: index)
        habitService.deleteHabit(id: id)
    }

    func markHabitCompleted(id: UUID) {
        guard let index = habits.firstIndex(where: { $0.id == id }) else { return }
        habits[index].markCompleted()
        habitService.updateHabit(habits[index])
    }

    func undoCompletion(id: UUID) {
        guard let index = habits.firstIndex(where: { $0.id == id }) else { return }
        habits[index].undoCompletion()
        habitService.updateHabit(habits[index])
    }

    func skipHabit(id: UUID) {
        guard let index = habits.firstIndex(where: { $0.id == id }) else { return }
        habits[index].skipToday()
        habitService.updateHabit(habits[index])
        habits = Array(habits)
    }

    func undoSkipHabit(id: UUID) {
        guard let index = habits.firstIndex(where: { $0.id == id }) else { return }
        habits[index].undoSkip()
        habitService.updateHabit(habits[index])
        habits = Array(habits)
    }

    func resetUncompletedHabits() {
        habitService.resetUncompletedHabits()
        loadHabits()
    }

    func updateSkippedDaysForAllHabits() {
        for index in habits.indices {
            habits[index].updateSkippedDays(startDate: habits[index].creationDate, endDate: Date())
        }
    }
}
