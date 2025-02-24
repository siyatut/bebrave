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

    @Published var dateRangeText: String = ""
    @Published var habitsProgress: [HabitProgress] = []
    @Published var selectedPeriod: Period = .week {
        didSet {
            referenceDate = Date()
            calculateProgress()
            updateDateRange()
        }
    }

    // MARK: - Private Properties

    private var referenceDate: Date = Date()
    private var habitsViewModel: HabitsViewModel
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(habitsViewModel: HabitsViewModel) {
        self.habitsViewModel = habitsViewModel
        self.selectedPeriod = UserDefaultsManager.shared.loadSelectedPeriod() ?? .week
        updateDateRange()
        setupBindings()
    }

    // MARK: - Private Methods

    private func setupBindings() {
        habitsViewModel.$habits
            .sink { [weak self] _ in
                self?.calculateProgress()
            }
            .store(in: &cancellables)

        $selectedPeriod
            .sink { [weak self] _ in
                self?.calculateProgress()
                self?.updateDateRange()
            }
            .store(in: &cancellables)
    }

    private func calculateProgress() {
        guard let interval = calculateDateInterval() else { return }

        let totalDays = calculateTotalDays(for: interval)

        let progress = calculateHabitProgress(for: interval, totalDays: totalDays)

        DispatchQueue.main.async {
            self.habitsProgress = progress
        }
    }

    // MARK: - Date Interval Calculation

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

    // MARK: - Habit Progress Calculation

    private func calculateTotalDays(for interval: DateInterval) -> Int {
        let calendar = Calendar.current
        let adjustedEnd = calendar.date(byAdding: .day, value: -1, to: interval.end) ?? interval.end
        return (calendar.dateComponents([.day], from: interval.start, to: adjustedEnd).day ?? 0) + 1
    }

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

    // MARK: - Period Selection

    func updateSelectedPeriod(_ period: Period) {
        selectedPeriod = period
        UserDefaultsManager.shared.saveSelectedPeriod(period)
    }

    // MARK: - Date Range Formatting

    private func updateDateRange() {
        dateRangeText = calculateDateRange(for: selectedPeriod)
    }

    private func calculateDateRange(for period: Period) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"

        let calendar = Calendar.current
        let today = Date()
        let startDate: Date?
        let endDate: Date?

        switch selectedPeriod {
        case .week:
            startDate = calendar.date(byAdding: .day, value: -6, to: today)
            endDate = today
        case .month:
            startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: today))
            endDate = startDate.flatMap { calendar.date(byAdding: .month, value: 1, to: $0)?.addingTimeInterval(-1) }
        case .halfYear:
            startDate = calendar.date(byAdding: .month, value: -5, to: today)
            endDate = today
        case .year:
            startDate = calendar.date(byAdding: .year, value: -1, to: today)
            endDate = today
        }

        guard let start = startDate, let end = endDate else {
            return ""
        }

        return "\(formatter.string(from: start))–\(formatter.string(from: end))"
    }
}
