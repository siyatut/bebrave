//
//  HabitsViewController.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 14/2/2567 BE.
//

#warning("№1: Добавить нужную отрисовку в чекбоксе по нажатию + степень закрашивания ячейки + изменение процента и числа 1/2, например")

#warning("№2: Нужно будет ещё добавить условия для пропуска привычки, когда по каким-то причинам пользователь не хочет выполнять её + условия, при котором она будет считаться невыполненной без его нажатия — после 00 по таймзоне юзера")

#warning("№3: Кнопку «Пропустить сегодня» добавить во вью контроллер «Изменить привычку»")

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
    
    lazy var emptyStateView: UIView = {
        let view = EmptyStateView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    lazy var addNewHabitButton: AddNewHabitView = {
        let view = AddNewHabitView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.parentFooterViewController = self
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
    
    // MARK: - Swipe gesture
    
    @objc func handleDeleteHabit(_ notification: Notification) {
        
        guard let cell = notification.object as? HabitsCell,
              let indexPath = collectionView.indexPath(for: cell) else { return }
        
        deleteHabit(at: indexPath)
    }
    
    @objc func handleChangeHabitTap(_ notification: Notification) {
        guard let cell = notification.object as? HabitsCell,
              let indexPath = collectionView.indexPath(for: cell) else { return }
        
        let habit = habits[indexPath.row]
        let changeHabitVC = ChangeHabitViewController(habit: habit)
        self.navigationController?.pushViewController(changeHabitVC, animated: true)
    }
    
    // MARK: - Tap action
    
    @objc func historyButtonTapped() {
        let history = HistoryViewController()
        self.navigationController?.pushViewController(history, animated: true)
    }
}


extension HabitsViewController {
    private class CustomNavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
        private let customAnimator = CustomPushAnimator()
        
        func navigationController(_ navigationController: UINavigationController,
                                  animationControllerFor operation: UINavigationController.Operation,
                                  from fromVC: UIViewController,
                                  to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return operation == .push ? customAnimator : nil
        }
    }
}
