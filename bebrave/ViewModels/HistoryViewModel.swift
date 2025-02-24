//
//  HistoryViewModel.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 24/2/2568 BE.
//

import Foundation
import Combine

class HistoryViewModel: ObservableObject {

    @Published var habitsProgress: [HabitProgress] = []
    @Published var selectedPeriod: Period = .week {
        didSet {
            referenceDate = Date()
            calculateProgress()
        }
    }

    private var referenceDate: Date = Date()
    private var habitsViewModel: HabitsViewModel
    private var cancellables = Set<AnyCancellable>()

    init(habitsViewModel: HabitsViewModel) {
        self.habitsViewModel = habitsViewModel

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

    func calculateProgress() {
        let calendar = Calendar.current
        let today = referenceDate
        var dateInterval: DateInterval?

        switch selectedPeriod {
        case .week:
            dateInterval = calendar.dateInterval(
                of: .weekOfYear,
                for: today
            )
        case .month:
            dateInterval = calendar.dateInterval(
                of: .month,
                for: today
            )
        case .halfYear:
            if let sixMonthsAgo = calendar.date(
                byAdding: .month,
                value: -5,
                to: today
            ),
               let startOfHalfYear = calendar.date(
                from: calendar.dateComponents([.year, .month],
                                              from: sixMonthsAgo)
               ),
               let endOfHalfYear = calendar.date(
                byAdding: .day,
                value: -1,
                to: calendar.date(byAdding: .month, value: 6, to: startOfHalfYear)!
               ) {
                dateInterval = DateInterval(start: startOfHalfYear, end: endOfHalfYear)
            }
        case .year:
            dateInterval = calendar.dateInterval(of: .year, for: today)
        }

        guard let interval = dateInterval else { return }

        let adjustedEnd = calendar.date(byAdding: .day, value: -1, to: interval.end) ?? interval.end
        let totalDays = (calendar.dateComponents([.day], from: interval.start, to: adjustedEnd).day ?? 0) + 1

        let progress = habitsViewModel.habits.map { habit -> HabitProgress in
            let completedDays = habit.progress
                .filter { $0.key >= interval.start && $0.key <= adjustedEnd && $0.value > 0 }
                .count
            let skippedDays = habit.skipDates.filter { $0 >= interval.start && $0 <= adjustedEnd }.count
            let remainingDays = totalDays - (completedDays + skippedDays)
            return HabitProgress(
                name: habit.title,
                completedDays: completedDays,
                totalDays: totalDays,
                skippedDays: skippedDays,
                remainingDays: remainingDays
            )
        }

        DispatchQueue.main.async {
            self.habitsProgress = progress
        }
    }
}
