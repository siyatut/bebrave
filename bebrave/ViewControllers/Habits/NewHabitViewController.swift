//
//  NewHabitViewController.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 15/1/2568 BE.
//

import UIKit

class NewHabitViewController: BaseHabitViewController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        didSaveNewHabitButton.setTitle("Добавить привычку", for: .normal)
    }

    // MARK: - Handle performing habit

    override func handleHabitSave(_ habit: Habit) {
        UserDefaultsManager.shared.addHabit(habit)
        delegate?.willHideEmptyStateView()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.delegate?.didAddNewHabit(habit)
            print("Новая привычка сохранена: \(habit.title)")
            self.dismiss(animated: true, completion: nil)
        }
    }
}
