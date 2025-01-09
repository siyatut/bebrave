//
//  HabitsViewController+UISetup.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 18/12/2567 BE.
//

import UIKit

extension HabitsViewController {
    
    // MARK: - History button
    
    func setupHistoryButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = AppStyle.Colors.secondaryColor
        configuration.image = .history
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
    
    // MARK: - Calendar label
    
    func setupCalendarLabel() {
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
    
    // MARK: - Empty state view
    
    func setupEmptyStateView() {
        view.addSubview(emptyStateView)
        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: view.topAnchor, constant: 180),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            emptyStateView.heightAnchor.constraint(equalToConstant: 312)
        ])
    }
    
    func updateEmptyState(animated: Bool = true) {
        let shouldShowEmptyState = habits.isEmpty
        
        emptyStateView.animateVisibility(
            isVisible: shouldShowEmptyState,
            duration: animated ? 0.4 : 0.0,
            transformEffect: true
        )
    }
    
    // MARK: - Add new habit button
    
    func setupAddNewHabitButton() {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = AppStyle.Colors.secondaryColor
        config.title = "Добавить привычку"
        config.image = .plus
        config.imagePadding = 4
        config.imagePlacement = .leading
        config.titleAlignment = .center
        config.attributedTitle = AttributedString(
            "Добавить привычку",
            attributes: AttributeContainer([.font: AppStyle.Fonts.regularFont(size: 16)])
        )
        
        addNewHabitButton.configuration = config
        addNewHabitButton.backgroundColor = .clear
        addNewHabitButton.layer.borderWidth = AppStyle.Sizes.borderWidth
        addNewHabitButton.layer.borderColor = AppStyle.Colors.borderColor.cgColor
        addNewHabitButton.layer.cornerRadius = AppStyle.Sizes.cornerRadius
        addNewHabitButton.layer.masksToBounds = true
        addNewHabitButton.addTarget(self, action: #selector(presentAddHabitController), for: .touchUpInside)
        addNewHabitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addNewHabitButton)
        
        NSLayoutConstraint.activate([
            addNewHabitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            addNewHabitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            addNewHabitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            addNewHabitButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    // MARK: - Notification
    
    func setupNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDeleteHabit(_:)),
            name: Notification.Name("DeleteHabit"),
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleChangeHabitTap(_:)),
            name: Notification.Name("ChangeHabit"),
            object: nil
        )
    }
}
