//
//  HabitsViewController.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 14/2/2567 BE.
//

#warning("№1: Переписать свайпы. Слева плавное через PanGesture — «Изменить» (открывает новый экран) и «Пропустить» закрашивает полосатым и не считает пропущенным этот день. Справа «Удалить» попробовать настроить через стандартное управление свайпами UISwipeActionsConfiguration. ИИ убеждает, что это всё-таки возможно")

#warning("№2: Отказалась от CompositionalLayout в пользу UICollectionViewFlowLayout, теперь надо всё переписать в соответствии с этим решением. Кнопка добавить привычку не должна быть футером коллекции, чтобы закрепить её за таббаром")

#warning("№3: Добавить нужную отрисовку в чекбоксе по нажатию + степень закрашивания ячейки + изменение процента и числа 1/2, например")

#warning("№4: Нужно будет ещё добавить условия для пропуска привычки, когда по каким-то причинам пользователь не хочет выполнять её + условия, при котором она будет считаться невыполненной")

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
    
// MARK: — Init
    
    init() {
        super.init(collectionViewLayout: HabitsFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Lifecycle view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppStyle.Colors.backgroundColor
        collectionView.delegate = self
        collectionView.dataSource = self
        
//        setupEmptyStateView()
//        updateEmptyState()

        setupNotificationObserver()
        
        setupHistoryButton()
        setupCalendarLabel()
        
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
            withReuseIdentifier: "OutlineBackgroundView"
        )
        collectionView.register(
            HeaderDaysCollectionView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CustomElement.collectionHeader.rawValue
        )
        collectionView.register(
            AddHabitFooterCollectionView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: CustomElement.collectionFooter.rawValue
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        habits = UserDefaultsManager.shared.loadHabits()
        print("Habits loaded: \(habits.map { $0.title })")
        
        collectionView.reloadData()
        print("CollectionView reloaded. Current habits count: \(habits.count)")
        
        DispatchQueue.main.async {
            self.updateCalendarLabel()
        }
    }
    
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
    
// MARK: - Swipe gesture
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleCellSwipeRight(_:)), name: Notification.Name("CellDidSwipeRight"), object: nil)
    }
    
#warning("Пока оставлю здесь, но скорее всего сам delete нужно будет вынести в отдельный метод или нет?")
    @objc private func handleCellSwipeRight(_ notification: Notification) {
        guard let cell = notification.object as? UICollectionViewCell,
              let indexPath = collectionView.indexPath(for: cell) else { return }
        
        // Проверяем, что это не ячейка DiaryWriteCell
        guard indexPath.item < habits.count else {
            print("Attempted to delete DiaryWriteCell or invalid index")
            return
        }
        
        // Получаем привычку, которую нужно удалить
        let habitToDelete = habits[indexPath.item]
        print("Habit to delete: \(habitToDelete.title)")
        
        UIView.animate(withDuration: 0.3, animations: {
            cell.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
            cell.alpha = 0
        }, completion: { _ in
            // Удаление данных из массива после завершения анимации
            
            self.habits.remove(at: indexPath.item)
            print("Habit removed from array. New habits count: \(self.habits.count)")
            
            // Удаляем привычку из UserDefaults
            UserDefaultsManager.shared.deleteHabit(id: habitToDelete.id)
            
            print("Habit deleted from UserDefaults. ID: \(habitToDelete.id)")
            
            // Удаление ячейки из коллекции
            self.collectionView.performBatchUpdates({
                self.collectionView.deleteItems(at: [indexPath])
            }, completion: { _ in
                // Сброс трансформации и прозрачности для повторного использования ячеек
                cell.transform = .identity
                cell.alpha = 1
                self.updateEmptyState()
            })
        })
    }
    
    
// MARK: - Action
    
    @objc func historyButtonTapped() {
        let history = HistoryViewController()
        self.navigationController?.pushViewController(history, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        let width = collectionView.bounds.width - 24
        return CGSize(width: width, height: 70) 
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        let width = collectionView.bounds.width - 24
        return CGSize(width: width, height: 48)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForSupplementaryViewOfKind kind: String,
        at indexPath: IndexPath
    ) -> CGSize {
        guard let customElement = CustomElement(rawValue: kind) else { return .zero }
        
        switch customElement {
        case .outlineBackground:
            let sectionHeight = CGFloat(habits.count) * 60 + CGFloat(habits.count - 1) * 8 // Высота всех ячеек + отступы
            return CGSize(width: collectionView.bounds.width - 24, height: sectionHeight)
            
        default:
            return .zero
        }
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        willDisplaySupplementaryView view: UICollectionReusableView,
        forElementKind elementKind: String,
        at indexPath: IndexPath
    ) {
        if elementKind == UICollectionView.elementKindSectionHeader,
           let header = view as? HeaderDaysCollectionView {
            headerView = header
            updateCalendarLabel()
        }
    }
}
