//
//  HabitsViewController.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 14/2/2567 BE.
//

import UIKit
import Combine

final class HabitsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - ViewModel

    let viewModel = HabitsViewModel()
    let headerViewModel: HeaderDaysViewModel

    // MARK: - UI Components

    weak var headerView: HeaderDaysCollectionView?
    weak var swipedCell: HabitCell?

    // MARK: - State Management

    private var cancellables = Set<AnyCancellable>()
    private var previousHabitCount: Int = 0

    // MARK: - UI components

    let calendarLabel = UILabel()
    let historyButton = UIButton()
    let createNewHabitButton = UIButton()

    let collectionView: UICollectionView = {
        let layout = HabitsLayout.createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = true
        return collectionView
    }()

    let emptyStateView = EmptyStateView(text: "Пора что-нибудь сюда добавить")

    // MARK: - Init

    init() {
        self.headerViewModel = HeaderDaysViewModel(habitsViewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppStyle.Colors.backgroundColor
        setupUI()
        setupBindings()

        // Вот это логика для невыполненной привычки:
        viewModel.resetUncompletedHabits()
        viewModel.loadHabits()
        scheduleMidnightCheck()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateSkippedDaysForAllHabits()
        collectionView.reloadData()
        updateEmptyState()
        DispatchQueue.main.async {
            self.updateCalendarLabel()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            navigationController?.delegate = nil
        }
    }

    // MARK: - Setup UI

    private func setupUI() {
        setupAddNewHabitButton()
        setupCollectionView()
        setupEmptyStateView()
        setupHistoryButton()
        setupCalendarLabel()
    }

    // MARK: - ViewModel Bindings

    private func setupBindings() {
        viewModel.$habits
            .receive(on: DispatchQueue.main)
            .sink { [weak self] habits in
                self?.handleHabitUpdates(habits: habits)
            }
            .store(in: &cancellables)
    }

    private func handleHabitUpdates(habits: [Habit]) {
        if habits.count < previousHabitCount {
            removeDeletedHabit()
        }
        previousHabitCount = habits.count
    }

    private func removeDeletedHabit() {
        guard let deletedIndex = (0..<previousHabitCount)
            .first(where: { !viewModel.habits.indices.contains($0) }) else { return }

        let indexPath = IndexPath(item: deletedIndex, section: 0)

        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: [indexPath])
        }, completion: { _ in
            self.updateEmptyState()
        })
    }

    // MARK: - User Actions

    @objc func historyButtonTapped() {
        let historyViewModel = HistoryViewModel(habitsViewModel: self.viewModel)
        let historyVC = HistoryViewController(viewModel: historyViewModel)
        self.navigationController?.pushViewController(historyVC, animated: true)
    }

    @objc func presentAddHabitController() {
        let newHabitVC = NewHabitViewController()
        newHabitVC.modalPresentationStyle = .pageSheet
        newHabitVC.delegate = self
        print("Открыт экран добавления привычки")
        self.present(newHabitVC, animated: true, completion: nil)
    }

    // MARK: - Handle Uncompleted Habits

    private func scheduleMidnightCheck() {
        let calendar = Calendar.current
        let now = Date()
        let nextMidnight = calendar.nextDate(
            after: now,
            matching: DateComponents(hour: 0),
            matchingPolicy: .strict
        ) ?? now

        Timer.scheduledTimer(
            timeInterval: nextMidnight.timeIntervalSince(now),
            target: self,
            selector: #selector(handleMidnight),
            userInfo: nil,
            repeats: false
        )
    }

    @objc private func handleMidnight() {
        viewModel.resetUncompletedHabits()
        collectionView.reloadData()
        scheduleMidnightCheck()
    }
}
