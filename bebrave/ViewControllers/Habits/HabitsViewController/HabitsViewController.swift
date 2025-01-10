//
//  HabitsViewController.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 14/2/2567 BE.
//

#warning("№1: Переделать swipe gesture по типу реализации в Telegram. Убрать реализацию именно свайпа, мб кроме удаления. Посмотреть по ситуации. Тогда слева будет: «Изменить», «Отменить», «Пропустить», а справа «Удалить». UPD: Почти сделала, но есть 2 проблемы: нужно, чтобы тап блокировался при свайпе для удаления привычки, а ещё ячейка не закрашивается в жёлтый при пропуске")

#warning("№2: Когда создать экран «История», проверить корректность работы статуса привычки «Не выполнена», если пользователь до 00:00 по своей таймзоне никак не взаимодействовал с ней")

import UIKit

class HabitsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Delegate
    
    private let navigationDelegate = CustomNavigationControllerDelegate()
    
    // MARK: - Data Source
    
    var habits: [Habit] = []
    
    // MARK: - Properties
    
    var headerView: HeaderDaysCollectionView?
    
    // MARK: - UI components
    
    let historyButton = UIButton()
    let calendarLabel = UILabel()
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
    
    lazy var emptyStateView: UIView = {
        let view = EmptyStateView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    // MARK: - Lifecycle view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppStyle.Colors.backgroundColor
        navigationController?.delegate = navigationDelegate
        setupAddNewHabitButton()
        setupCollectionView()
        setupEmptyStateView()
        setupHistoryButton()
        setupCalendarLabel()

        // Вот это логика для невыполненной привычки:
        UserDefaultsManager.shared.resetUncompletedHabits()
        habits = UserDefaultsManager.shared.loadHabits()
        scheduleMidnightCheck()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        habits = UserDefaultsManager.shared.loadHabits()
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
    
    // MARK: - Tap actions
    
    @objc func historyButtonTapped() {
        let history = HistoryViewController()
        self.navigationController?.pushViewController(history, animated: true)
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
        let nextMidnight = calendar.nextDate(after: now, matching: DateComponents(hour: 0), matchingPolicy: .strict) ?? now

        let timer = Timer(fireAt: nextMidnight, interval: 0, target: self, selector: #selector(handleMidnight), userInfo: nil, repeats: false)
        RunLoop.main.add(timer, forMode: .common)
    }

    @objc private func handleMidnight() {
        UserDefaultsManager.shared.resetUncompletedHabits()
        habits = UserDefaultsManager.shared.loadHabits()
        collectionView.reloadData()
        scheduleMidnightCheck()
    }
}


