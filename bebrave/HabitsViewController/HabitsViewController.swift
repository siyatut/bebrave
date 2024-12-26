//
//  HabitsViewController.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 14/2/2567 BE.
//

#warning("№1: Переписать свайпы. Слева плавное через PanGesture — «Изменить» (открывает новый экран) и «Пропустить» закрашивает полосатым и не считает пропущенным этот день. Справа «Удалить» попробовать настроить через стандартное управление свайпами UISwipeActionsConfiguration. ИИ убеждает, что это всё-таки возможно")

#warning("№2: Добавить нужную отрисовку в чекбоксе по нажатию + степень закрашивания ячейки + изменение процента и числа 1/2, например")

#warning("№3: Нужно будет ещё добавить условия для пропуска привычки, когда по каким-то причинам пользователь не хочет выполнять её + условия, при котором она будет считаться невыполненной")

import UIKit

class HabitsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Data Source
    
    var habits: [Habit] = []
    
    // MARK: - Properties
    
    var headerView: HeaderDaysCollectionView?
    
    // MARK: - UI components
    
    var collectionView: UICollectionView!
    let historyButton = UIButton()
    let calendarLabel = UILabel()
    
    private lazy var emptyStateView: UIView = {
        let view = EmptyStateView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var addNewHabitButton: AddNewHabitView = {
        let view = AddNewHabitView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.parentFooterViewController = self
        return view
    }()
    
    // MARK: - Lifecycle view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppStyle.Colors.backgroundColor
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
    
    // MARK: - Setup collection view
    
    func setupCollectionView() {
        let layout = HabitsLayout.createLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
#warning("Появляется сетка после удаления элементов и не работает скроллинг")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(
            HabitsCell.self,
            forCellWithReuseIdentifier: CustomElement.habitsCell.rawValue
        )
        collectionView.register(
            DiaryWriteCell.self,
            forCellWithReuseIdentifier: CustomElement.writeDiaryCell.rawValue
        )
        collectionView.register(
            OutlineBackgroundView.self,
            forSupplementaryViewOfKind: CustomElement.outlineBackground.rawValue,
            withReuseIdentifier: CustomElement.outlineBackground.rawValue
        )
        collectionView.register(
            HeaderDaysCollectionView.self,
            forSupplementaryViewOfKind: CustomElement.collectionHeader.rawValue,
            withReuseIdentifier: CustomElement.collectionHeader.rawValue
        )
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: addNewHabitButton.topAnchor, constant: -12)
        ])
    }
    
    // MARK: - Setup components
    
    private func setupEmptyStateView() {
        view.addSubview(emptyStateView)
        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: view.topAnchor, constant: 180),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            emptyStateView.heightAnchor.constraint(equalToConstant: 312)
        ])
    }
    
    func updateEmptyState() {
        emptyStateView.isHidden = !habits.isEmpty
    }
    
    
    private func setupAddNewHabitButton() {
        view.addSubview(addNewHabitButton)
        
        NSLayoutConstraint.activate([
            addNewHabitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            addNewHabitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            addNewHabitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            addNewHabitButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    // MARK: - Notification observer
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleCellSwipeRight(_:)), name: Notification.Name("CellDidSwipeRight"), object: nil)
    }
    
    // MARK: - Swipe gesture
    
    @objc private func handleCellSwipeRight(_ notification: Notification) {
        
        guard let cell = notification.object as? UICollectionViewCell,
              let indexPath = collectionView.indexPath(for: cell) else { return }
        
        deleteHabit(at: indexPath)
    }
    
    
    // MARK: - Tap action
    
    @objc func historyButtonTapped() {
        let history = HistoryViewController()
        self.navigationController?.pushViewController(history, animated: true)
    }
}
