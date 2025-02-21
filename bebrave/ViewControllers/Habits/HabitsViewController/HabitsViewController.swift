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

    // MARK: - Properties

    let viewModel = HabitsViewModel()
    var headerView: HeaderDaysCollectionView?
    weak var swipedCell: HabitCell?
    private var cancellables = Set<AnyCancellable>()

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

    private func setupBindings() {
        viewModel.$habits
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                // self?.collectionView.reloadData()
                self?.updateEmptyState()
            }
            .store(in: &cancellables)
    }

    // MARK: - Tap actions

    @objc func historyButtonTapped() {
        let historyVC = HistoryViewController()
        historyVC.viewModel = self.viewModel
        self.navigationController?.pushViewController(historyVC, animated: true)
    }

    @objc func presentAddHabitController() {
        let newHabitVC = NewHabitViewController()
        newHabitVC.modalPresentationStyle = .pageSheet
        newHabitVC.delegate = self
        print("Открыт экран добавления привычки")
        self.present(newHabitVC, animated: true, completion: nil)
    }

    // MARK: - Handle uncompleted habits

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
