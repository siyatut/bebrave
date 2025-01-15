//
//  NewHabitViewController.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 15/1/2568 BE.
//

import UIKit

class NewHabitViewController: BaseHabitViewController {
    
    override func handleHabitSave(_ habit: Habit) {
        UserDefaultsManager.shared.addHabit(habit)
        delegate?.willHideEmptyStateView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.delegate?.didAddNewHabit(habit)
            print("Новая привычка сохранена: \(habit.title)")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        didSaveNewHabitButton.setTitle("Добавить привычку", for: .normal)
        didSaveNewHabitButton.addTarget(self, action: #selector(createHabitAction), for: .touchUpInside)
    }
    
    @objc private func createHabitAction() {
        
        guard let newHabit = createHabitFromFields() else { return }
        delegate?.didAddNewHabit(newHabit)
        dismiss(animated: true)
    }
}
