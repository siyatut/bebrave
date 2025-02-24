//
//  HabitsViewController.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 14/2/2567 BE.
//

// swiftlint:disable:next line_length
// TODO: - Когда создать экран «История», проверить корректность работы статуса привычки «Не выполнена», если пользователь до 00:00 по своей таймзоне никак не взаимодействовал с ней")

import UIKit
import Combine

class HabitsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - ViewModel

    let viewModel = HabitsViewModel()
    lazy var headerViewModel = HeaderDaysViewModel(habitsViewModel: viewModel)

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

    lazy var collectionView: UICollectionView = {
        let layout = HabitsLayout.createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = true
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    lazy var emptyStateView: EmptyStateView = {
        let view = EmptyStateView(text: "Пора что-нибудь сюда добавить")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppStyle.Colors.backgroundColor
        setupAddNewHabitButton()
        setupCollectionView()
        setupEmptyStateView()
        setupHistoryButton()
        setupCalendarLabel()
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

    // MARK: - ViewModel Bindings

    private func setupBindings() {
        viewModel.$habits
            .receive(on: DispatchQueue.main)
            .sink { [weak self] habits in
                guard let self = self else { return }
                if habits.count < self.previousHabitCount {
                    let deletedIndex = (0..<self.previousHabitCount)
                        .first(where: { !habits.indices.contains($0) })

                    if let deletedIndex = deletedIndex {
                        let indexPath = IndexPath(item: deletedIndex, section: 0)

                        collectionView.performBatchUpdates({
                            self.collectionView.deleteItems(at: [indexPath])
                        }, completion: { _ in
                            self.updateEmptyState()
                        })
                    }
                }

                self.previousHabitCount = habits.count
            }
            .store(in: &cancellables)
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

    func scheduleMidnightCheck() {
        let calendar = Calendar.current
        let now = Date()
        let nextMidnight = calendar.nextDate(
            after: now,
            matching: DateComponents(hour: 0),
            matchingPolicy: .strict
        ) ?? now
        let timer = Timer(
            fireAt: nextMidnight,
            interval: 0, target: self,
            selector: #selector(handleMidnight),
            userInfo: nil, repeats: false
        )
        RunLoop.main.add(timer, forMode: .common)
    }

    @objc private func handleMidnight() {
        viewModel.resetUncompletedHabits()
        collectionView.reloadData()
        scheduleMidnightCheck()
    }
}
