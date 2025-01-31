//
//  HistoryViewConroller.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 28/2/2567 BE.
//
// swiftlint:disable:next line_length
// TODO: - Настроить отображение прогресса и закрашивания в соответствии со статусом: зелёный, полосатый зелёный, серый. UPD: с зелёным и серым вроде ок, но паттерн для спипа отрисовать не получилось

import UIKit

class HistoryViewController: UIViewController {

    // MARK: - UI Components

    private var collectionView: UICollectionView!

    private lazy var emptyStateView: EmptyStateView = {
        let view = EmptyStateView(text: "История пока пуста")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    // MARK: - Data

    var habits: [Habit] = []
    var habitsProgress: [HabitProgress] = []

    // MARK: - Init

    init(habits: [Habit]) {
        self.habits = habits
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppStyle.Colors.backgroundColor
        navigationController?.navigationBar.tintColor = AppStyle.Colors.secondaryColor
        setupCollectionView()
        setupEmptyStateView()
        let initialPeriod = UserDefaultsManager.shared.loadSelectedPeriod() ?? .week
        calculateProgress(for: initialPeriod)
    }

    // MARK: - Setup

    private func setupCollectionView() {
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: ProgressLayout.createLayout()
        )
        collectionView.dataSource = self

        collectionView.register(
            ProgressCell.self,
            forCellWithReuseIdentifier: CustomElement.progressCell.rawValue
        )

        collectionView.register(
            HistoryHeaderView.self,
            forSupplementaryViewOfKind: CustomElement.historyHeader.rawValue,
            withReuseIdentifier: CustomElement.historyHeader.rawValue
        )

        collectionView.register(
            OutlineBackgroundView.self,
            forSupplementaryViewOfKind: CustomElement.outlineBackground.rawValue,
            withReuseIdentifier: CustomElement.outlineBackground.rawValue
        )

        view.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupEmptyStateView() {
        view.addSubview(emptyStateView)

        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            emptyStateView.heightAnchor.constraint(equalToConstant: 312)
        ])
        setupEmptyStateVisibility()
    }

    private func setupEmptyStateVisibility() {
        emptyStateView.isHidden = !habits.isEmpty
    }

    // MARK: - Data Handling

    private func calculateProgress(for period: Period) {
        // TODO: - Опять что-то неправильно здесь посчитывается. Или UI некорректно обновляется. Только при перезагрузки, а нужно чтобы и при смене экрана апдейтился
        let calendar = Calendar.current
        let today = Date()

        var dateInterval: DateInterval?

        switch period {
        case .week:
            dateInterval = calendar.dateInterval(of: .weekOfYear, for: today)

        case .month:
            dateInterval = calendar.dateInterval(of: .month, for: today)

        case .halfYear:
            if let sixMonthsAgo = calendar.date(byAdding: .month, value: -5, to: today),
               let startOfHalfYear = calendar.date(from: calendar.dateComponents([.year, .month], from: sixMonthsAgo)),
            let endOfHalfYear = calendar.date(
                byAdding: .day,
                value: -1,
                to: calendar.date(byAdding: .month, value: 6,
                to: startOfHalfYear)!) {
                dateInterval = DateInterval(start: startOfHalfYear, end: endOfHalfYear)
            }

        case .year:
            dateInterval = calendar.dateInterval(of: .year, for: today)
        }

        guard let interval = dateInterval else { return }

        let adjustedEnd = calendar.date(byAdding: .day, value: -1, to: interval.end) ?? interval.end
        let totalDays = calendar.dateComponents([.day], from: interval.start, to: adjustedEnd).day! + 1

        habitsProgress = habits.map { habit in
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

        collectionView.reloadData()
    }

    func updateData(for period: Period) {
        calculateProgress(for: period)
        collectionView.reloadData()
    }
}
