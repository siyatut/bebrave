//
//  HabitsViewController.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 14/2/2567 BE.
//

#warning("№1: Через LongPress добавить меню? Чтобы можно было «отменить выполнение» и «пропустить сегодня». Также нужно будет условие, при котором привычка будет считаться невыполненной без нажатия — после 00 по таймзоне юзера")

import UIKit

class HabitsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Delegate
    
    private let navigationDelegate = CustomNavigationControllerDelegate()
    
    // MARK: - Data Source
    
    var habits: [Habit] = []
    
    // MARK: - Properties
    
    var headerView: HeaderDaysCollectionView?
    
    // MARK: - UI components
    
    var collectionView: UICollectionView!
    let historyButton = UIButton()
    let calendarLabel = UILabel()
    lazy var addNewHabitButton = AddNewHabitView(parentViewController: self)
    
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
        setupNotificationObserver()
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
    
    func updateEmptyState(animated: Bool = true) {
        let shouldShowEmptyState = habits.isEmpty
        
        emptyStateView.animateVisibility(
            isVisible: shouldShowEmptyState,
            duration: animated ? 0.4 : 0.0,
            transformEffect: true
        )
    }
    
    // MARK: - Tap action
    
    @objc func historyButtonTapped() {
        let history = HistoryViewController()
        self.navigationController?.pushViewController(history, animated: true)
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
        scheduleMidnightCheck() // Перезапуск таймера для следующего дня
    }
}


extension HabitsViewController: HabitCellDelegate {
    func markHabitAsNotCompleted(habit: Habit) {
        var updatedHabit = habit
        updatedHabit.resetToday()
        UserDefaultsManager.shared.updateHabit(updatedHabit)
        collectionView.reloadData()
    }

    func skipToday(habit: Habit) {
        var updatedHabit = habit
        updatedHabit.skipToday()
        UserDefaultsManager.shared.updateHabit(updatedHabit)
        collectionView.reloadData()
    }
}
