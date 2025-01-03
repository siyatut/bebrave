//
//  ChangeHabitViewController.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 2/1/2568 BE.
//

import UIKit

class ChangeHabitViewController: UIViewController {
    
    private var habit: Habit
    
    init(habit: Habit) {
        self.habit = habit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppStyle.Colors.backgroundColor
    }
}
