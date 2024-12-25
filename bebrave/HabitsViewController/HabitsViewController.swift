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

// MARK: - Delegate Protocol

protocol NewHabitDelegate: AnyObject {
    func didAddNewHabit(_ habit: Habit)
}

class HabitsViewController: UICollectionViewController {
    
// MARK: - Data Source
    
    var habits: [Habit] = []
    
// MARK: - Properties
    
    var headerView: HeaderDaysCollectionView?
    
// MARK: - UI components
    
    let historyButton = UIButton()
    let calendarLabel = UILabel()
    
    private lazy var emptyStateView: UIView = {
        let view = EmptyStateView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var addNewHabitView: AddNewHabitView = {
        let view = AddNewHabitView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.parentFooterViewController = self
        return view
    }()
    
// MARK: — Init
    
    init() {
        super.init(collectionViewLayout: HabitsLayout.createLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Lifecycle view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppStyle.Colors.backgroundColor

        setupEmptyStateView()
        setupNotificationObserver()
        
        setupHistoryButton()
        setupCalendarLabel()
        setupAddNewHabitButton()
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        habits = UserDefaultsManager.shared.loadHabits()
        print("Habits loaded: \(habits.map { $0.title })")
        
        collectionView.reloadData()
        print("CollectionView reloaded. Current habits count: \(habits.count)")
        
        updateEmptyState()
        
        DispatchQueue.main.async {
            self.updateCalendarLabel()
        }
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
        view.addSubview(addNewHabitView)
        
        NSLayoutConstraint.activate([
            addNewHabitView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            addNewHabitView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            addNewHabitView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            addNewHabitView.heightAnchor.constraint(equalToConstant: 50)
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
