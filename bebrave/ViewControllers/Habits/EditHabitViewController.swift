//
//  ChangeHabitViewController.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 2/1/2568 BE.
//

import UIKit

class EditHabitViewController: BaseHabitViewController {
    
    var habitToEdit: Habit?
    
    init(habit: Habit) {
        self.habitToEdit = habit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let habit = habitToEdit {
            habitTextField.text = habit.title
            timesPerDayTextField.text = "\(habit.frequency)"
            selectedDays = habit.daysOfWeek
            setupDaysOfWeekStack()
            monthsTextField.text = "\(habit.monthFrequency)"
        }
        
        didSaveNewHabitButton.setTitle("Сохранить изменения", for: .normal)
        didSaveNewHabitButton.addTarget(self, action: #selector(saveHabit), for: .touchUpInside)
    }
    
    override func handleHabitSave(_ habit: Habit) {
        
        UserDefaultsManager.shared.updateHabit(habit)
        delegate?.didEditHabit(habit)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.delegate?.didEditHabit(habit)
            print("Измененная привычка сохранена: \(habit.title)")
            self.dismiss(animated: true, completion: nil)
        }
    }
}
