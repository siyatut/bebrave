//
//  HistoryViewModel.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 24/2/2568 BE.
//

import Foundation
import Combine

class HistoryViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var habitsProgress: [HabitProgress] = []
    @Published var selectedPeriod: Period = .week {
        didSet {
            referenceDate = Date()
            calculateProgress()
        }
    }

    // MARK: - Private Properties

    private var referenceDate: Date = Date()
    private var habitsViewModel: HabitsViewModel
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(habitsViewModel: HabitsViewModel) {
        self.habitsViewModel = habitsViewModel
        setupBindings()
    }

    private func setupBindings() {
        habitsViewModel.$habits
            .sink { [weak self] _ in
                self?.calculateProgress()
            }
            .store(in: &cancellables)

        $selectedPeriod
            .sink { [weak self] _ in
                self?.calculateProgress()
            }
            .store(in: &cancellables)
    }

    // MARK: - Private Methods

    func calculateProgress() {
        guard let interval = calculateDateInterval() else { return }

        let totalDays = calculateTotalDays(for: interval)

        let progress = calculateHabitProgress(for: interval, totalDays: totalDays)

        DispatchQueue.main.async {
            self.habitsProgress = progress
        }
    }

    // MARK: - Determine the date interval

    private func calculateDateInterval() -> DateInterval? {
        let calendar = Calendar.current
        let today = referenceDate

        switch selectedPeriod {
        case .week:
            return calendar.dateInterval(of: .weekOfYear, for: today)

        case .month:
            return calendar.dateInterval(of: .month, for: today)

        case .halfYear:
            guard
                let sixMonthsAgo = calendar.date(
                byAdding: .month, value: -5, to: today
            ),
                let startOfHalfYear = calendar.date(
                from: calendar.dateComponents([.year, .month], from: sixMonthsAgo)
            ),
                let sixMonthsLater = calendar.date(
                byAdding: .month, value: 6, to: startOfHalfYear
            ),
                let endOfHalfYear = calendar.date(
                byAdding: .day, value: -1, to: sixMonthsLater
            )
            else { return nil }

            return DateInterval(start: startOfHalfYear, end: endOfHalfYear)

        case .year:
            return calendar.dateInterval(of: .year, for: today)
        }
    }

    // MARK: - Calculate the total number of days

    private func calculateTotalDays(for interval: DateInterval) -> Int {
        let calendar = Calendar.current
        let adjustedEnd = calendar.date(byAdding: .day, value: -1, to: interval.end) ?? interval.end
        return (calendar.dateComponents([.day], from: interval.start, to: adjustedEnd).day ?? 0) + 1
    }

    // MARK: - Calculate habit progress

    private func calculateHabitProgress(for interval: DateInterval, totalDays: Int) -> [HabitProgress] {
        return habitsViewModel.habits.map { habit in
            let completedDays = habit.progress
                .filter { $0.key >= interval.start && $0.key <= interval.end && $0.value > 0 }
                .count
            let skippedDays = habit.skipDates.filter { $0 >= interval.start && $0 <= interval.end }.count
            let remainingDays = totalDays - (completedDays + skippedDays)

            return HabitProgress(
                name: habit.title,
                completedDays: completedDays,
                totalDays: totalDays,
                skippedDays: skippedDays,
                remainingDays: remainingDays
            )
        }
    }
}
