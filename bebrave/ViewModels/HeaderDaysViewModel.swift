//
//  HeaderDaysViewModel.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 24/2/2568 BE.
//

import Foundation
import Combine

final class HeaderDaysViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var daysData: [(date: Date, emoji: String)] = []

    // MARK: - Private Properties

    private var calendar = Calendar.current
    private var habitsViewModel: HabitsViewModel
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(habitsViewModel: HabitsViewModel) {
        self.habitsViewModel = habitsViewModel
        setupBindings()
        generateDaysForCurrentWeek()
    }

    // MARK: - Data Binding

    private func setupBindings() {
        habitsViewModel.$habits
            .sink { [weak self] _ in
                self?.generateDaysForCurrentWeek()
            }
            .store(in: &cancellables)
    }

    // MARK: - Generate Days Data

    private func generateDaysForCurrentWeek() {
        let today = Date()
        calendar.firstWeekday = 2

        guard let startOfWeek = calendar.date(
            from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)
        ) else {
            assertionFailure("Failed to determine start of the week")
            return
        }

        let habits = habitsViewModel.habits

        daysData = (0..<7).compactMap { dayOffset -> (date: Date, emoji: String)? in
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek) else { return nil }
            let startOfDay = calendar.startOfDay(for: date)
            let emoji = HabitEmojiCalculator.calculateEmoji(for: startOfDay, habits: habits, calendar: calendar)
            return (date: startOfDay, emoji: emoji)
        }
    }
}
