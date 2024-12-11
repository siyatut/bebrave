//
//  HabitsViewController.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 14/2/2567 BE.
//

#warning("№1: Перепроверить, появляется ли серое вью после удаления привычек.")

#warning("№2: Есть проблема с нажатием на ячейку, поэтому и не получается добавить действия свайпами. Когда сделаю это, можно переходить к следующему пункту")

#warning("№3: Добавить нужную отрисовку в чекбоксе по нажатию + степень закрашивания ячейки + изменение процента и числа 1/2, например")

#warning("№4: Нужно будет ещё добавить условия для пропуска привычки, когда по каким-то причинам пользователь не хочет выполнять её + условия, при котором она будет считаться невыполненной")

#warning("№5: Дополнительно обернуть dequeueReusableCell в кастомный хелпер, чтобы унифицировать обработку ошибок?")

import UIKit

// MARK: - Custom Elements

enum CustomElement: String {
    case collectionHeader
    case collectionFooter
    case outlineBackground
    case habitsCell
    case writeDiaryCell
}

// MARK: - Delegate Protocol

protocol NewHabitDelegate: AnyObject {
    func didAddNewHabit(_ habit: Habit)
}

class HabitsViewController: UICollectionViewController {
 
// MARK: - Data Source
    
    private var habits: [Habit] = []

// MARK: - Properties
    
    private var headerView: HeaderDaysCollectionView?
    
// MARK: - UI components
    
    let historyButton = UIButton()
    let calendarLabel = UILabel()
    
// MARK: — Init
    
    init() {
        super.init(collectionViewLayout: HabitsViewController.createLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Create layout
    
    static func createLayout() -> UICollectionViewLayout {
        let provider: UICollectionViewCompositionalLayoutSectionProvider = { section, environment in
// нужна ли вообще строка снизу. когда добавлю возможность удаления привычек, хорошо бы перепроверить
            if section == 1 {
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)
                    )
                )
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(312)
                    ),
                    subitems: [item]
                )
                let section = NSCollectionLayoutSection(group: group)
// наверное, нужно будет поменять настройку ниже, у другой секции по 12
                section.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
                return section
            }
            let background = NSCollectionLayoutSupplementaryItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                ),
                elementKind: CustomElement.outlineBackground.rawValue,
                containerAnchor: .init(edges: .all)
            )
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60)
                ),
                supplementaryItems: [background]
            )
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60)
                ),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 0, leading: 12, bottom: 0, trailing: 12)
            section.interGroupSpacing = 8
            return section
        }
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(70)
            ),
            elementKind: CustomElement.collectionHeader.rawValue,
            alignment: .top,
            absoluteOffset: .init(x: 0, y: -24)
        )
        header.extendsBoundary = true
        header.contentInsets = .init(top: 0, leading: 12, bottom: 0, trailing: 12)
        
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(48)
            ),
            elementKind: CustomElement.collectionFooter.rawValue,
            alignment: .bottom,
            absoluteOffset: .init(x: 0, y: 24)
        )
        footer.extendsBoundary = true
        footer.contentInsets = .init(top: 0, leading: 12, bottom: 0, trailing: 12)
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.boundarySupplementaryItems = [header, footer]
        return UICollectionViewCompositionalLayout(sectionProvider: provider, configuration: configuration)
    }
    
// MARK: - Lifecycle view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppStyle.Colors.backgroundColor
        collectionView.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
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
            HeaderDaysCollectionView.self,
            forSupplementaryViewOfKind: CustomElement.collectionHeader.rawValue,
            withReuseIdentifier: CustomElement.collectionHeader.rawValue
        )
        collectionView.register(
            OutlineBackgroundView.self,
            forSupplementaryViewOfKind: CustomElement.outlineBackground.rawValue,
            withReuseIdentifier: CustomElement.outlineBackground.rawValue
        )
        collectionView.register(
            AddNewHabitView.self,
            forSupplementaryViewOfKind: CustomElement.collectionFooter.rawValue,
            withReuseIdentifier: CustomElement.collectionFooter.rawValue
        )
        collectionView.register(
            EmptyStateCell.self,
            forCellWithReuseIdentifier: "EmptyStateCell"
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        habits = UserDefaultsManager.shared.loadHabits()
        collectionView.reloadData()
        DispatchQueue.main.async {
            self.updateCalendarLabel()
        }
    }
    
// MARK: - Action
    
    @objc private func historyButtonTapped() {
        let history = HistoryViewController()
        self.navigationController?.pushViewController(history, animated: true)
    }
}

// MARK: — UICollectionViewDelegate

extension HabitsViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return habits.isEmpty ? 2 : 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if habits.isEmpty && section == 1 {
            return 1
        }
        if section == 0 {
            return habits.count + 1
        }
        return 0
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if habits.isEmpty && indexPath.section == 1 {
            guard let emptyStateCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "EmptyStateCell",
                for: indexPath
            ) as? EmptyStateCell else {
                // Если приведение не удалось, возвращаем пустую ячейку и выводим ошибку
                assertionFailure("Failed to dequeue EmptyStateCell")
                return UICollectionViewCell()
            }
            return emptyStateCell
        }
        if indexPath.section == 0 {
            if indexPath.item == habits.count {
                guard let diaryCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CustomElement.writeDiaryCell.rawValue,
                    for: indexPath
                ) as? DiaryWriteCell else {
                    assertionFailure("Failed to dequeue DiaryWriteCell")
                    return UICollectionViewCell()
                }
                return diaryCell
            } else {
                guard let habitCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CustomElement.habitsCell.rawValue,
                    for: indexPath
                ) as? HabitsCell else {
                    assertionFailure("Failed to dequeue HabitsCell")
                    return UICollectionViewCell()
                }
                let habit = habits[indexPath.item]
                habitCell.configure(with: habit)
                return habitCell
            }
        }
        assertionFailure("Unhandled case in cellForItemAt. Check section or indexPath logic.")
        return UICollectionViewCell()
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind
        kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let customElement = CustomElement(rawValue: kind) else {
            assertionFailure("Unexpected supplementary kind: \(kind)")
            return UICollectionReusableView()
        }
        switch customElement {
        case .collectionFooter:
            if let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: CustomElement.collectionFooter.rawValue,
                for: indexPath
            ) as? AddNewHabitView {
                footer.backgroundColor = AppStyle.Colors.backgroundColor
                footer.parentFooterViewController = self
                return footer
            }
            assertionFailure("Failed to dequeue AddNewHabitView")
            return UICollectionReusableView()
        case .collectionHeader:
            if let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: CustomElement.collectionHeader.rawValue,
                for: indexPath
            ) as? HeaderDaysCollectionView {
                header.backgroundColor = AppStyle.Colors.backgroundColor
                header.parentHeaderViewController = self
                headerView = header
                return header
            }
            assertionFailure("Failed to dequeue HeaderDaysCollectionView")
            return UICollectionReusableView()
        case .outlineBackground:
            if let outlineBackground = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: CustomElement.outlineBackground.rawValue,
                for: indexPath
            )as? OutlineBackgroundView {
                return outlineBackground
            }
            assertionFailure("Failed to dequeue OutlineBackgroundView")
            return UICollectionReusableView()
        default:
            assertionFailure("Unhandled custom element: \(customElement)")
            return UICollectionReusableView()
        }
    }
}

// MARK: — Customise navigation's items

extension HabitsViewController {
    
    private func setupHistoryButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = AppStyle.Colors.secondaryColor
        configuration.image = UIImage(named: "History")
        configuration.imagePadding = 4
        configuration.imagePlacement = .leading

        let titleAttributes = AttributeContainer([
            .font: AppStyle.Fonts.regularFont(size: 16)
            ])
        configuration.attributedTitle = AttributedString("История", attributes: titleAttributes)
        historyButton.configuration = configuration
        historyButton.addTarget(self, action: #selector(historyButtonTapped), for: .touchUpInside)

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: historyButton)
    }
    
    private func setupCalendarLabel() {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        calendarLabel.textColor = AppStyle.Colors.textColor
        calendarLabel.font = AppStyle.Fonts.boldFont(size: 20)
        calendarLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(calendarLabel)
        
        NSLayoutConstraint.activate([
            calendarLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 4),
            calendarLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            calendarLabel.topAnchor.constraint(equalTo: container.topAnchor),
            calendarLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            
        ])
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: container)
    }
}

// MARK: - NewHabitDelegate 

extension HabitsViewController: NewHabitDelegate {
    func didAddNewHabit(_ habit: Habit) {
        habits.append(habit)
        collectionView.reloadData()
    }
}

// MARK: - Calendar label update

extension HabitsViewController {
    func updateCalendarLabel() {
        guard let header = headerView else {
            print("Header is not visible or initialized.")
            return
        }
        
        let dates = header.getDisplayedDates()
        
        guard let firstDate = dates.first, let lastDate = dates.last else {
            assertionFailure("Dates array is empty")
            return
        }
        
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "LLLL"
        
        let firstMonth = formatter.string(from: firstDate).capitalized
        let lastMonth = formatter.string(from: lastDate).capitalized
        
        if calendar.isDate(firstDate, equalTo: lastDate, toGranularity: .month) {
            calendarLabel.text = firstMonth
        } else {
            calendarLabel.text = "\(firstMonth) - \(lastMonth)"
        }
    }
}

