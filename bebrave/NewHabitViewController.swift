//
//  NewHabitViewController.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 16/10/2567 BE.
//

import UIKit

class NewHabitViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - UI components
    
    private let emojiImageView = UIImageView()
    private let promiseLabel = UILabel()
    private let habitTextField = UITextField()
    private let timesPerDayTextField = UITextField()
    private let timesPerDayLabel = UILabel()
    private let daysOfWeekStack = UIStackView()
    private let monthsTextField = UITextField()
    private let monthsLabel = UILabel()
    
    private let errorLabel = UILabel() // Displays validation errors
    
    private var selectedDays: [Bool] = Array(repeating: false, count: 7)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupComponents()
    }
    
    // MARK: - Set up components
    
    private func setupComponents() {
        emojiImageView.image = UIImage(named: "EmojiNewHabit")
        emojiImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emojiImageView)
        
        promiseLabel.text = "Я обещаю себе"
        promiseLabel.font = UIFont.boldSystemFont(ofSize: 24)
        promiseLabel.textAlignment = .left
        promiseLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(promiseLabel)
        
        habitTextField.placeholder = "Делать что-то"
        habitTextField.borderStyle = .roundedRect
        habitTextField.delegate = self
        habitTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(habitTextField)
        
        timesPerDayTextField.placeholder = "1"
        timesPerDayTextField.textAlignment = .center
        timesPerDayTextField.borderStyle = .roundedRect
        timesPerDayTextField.keyboardType = .numberPad
        timesPerDayTextField.delegate = self
        timesPerDayTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timesPerDayTextField)
        
        timesPerDayLabel.text = "раз в день"
        timesPerDayLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timesPerDayLabel)
        
        setupDaysOfWeekStack()
        daysOfWeekStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(daysOfWeekStack)
        
        monthsTextField.placeholder = "1"
        monthsTextField.textAlignment = .center
        monthsTextField.borderStyle = .roundedRect
        monthsTextField.keyboardType = .numberPad
        monthsTextField.delegate = self
        monthsTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(monthsTextField)
        
        monthsLabel.text = "месяц"
        monthsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(monthsLabel)
        
        errorLabel.textColor = .red
        errorLabel.font = UIFont.systemFont(ofSize: 14)
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            
            emojiImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 102),
            emojiImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emojiImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -321),
            emojiImageView.heightAnchor.constraint(equalToConstant: 48),
            
            promiseLabel.topAnchor.constraint(equalTo: emojiImageView.bottomAnchor, constant: 16),
            promiseLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            promiseLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            habitTextField.topAnchor.constraint(equalTo: promiseLabel.bottomAnchor, constant: 16),
            habitTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            habitTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            timesPerDayTextField.topAnchor.constraint(equalTo: habitTextField.bottomAnchor, constant: 16),
            timesPerDayTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            timesPerDayTextField.widthAnchor.constraint(equalToConstant: 50),
            
            timesPerDayLabel.centerYAnchor.constraint(equalTo: timesPerDayTextField.centerYAnchor),
            timesPerDayLabel.leadingAnchor.constraint(equalTo: timesPerDayTextField.trailingAnchor, constant: 8),
            
            daysOfWeekStack.topAnchor.constraint(equalTo: timesPerDayTextField.bottomAnchor, constant: 16),
            daysOfWeekStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            daysOfWeekStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            monthsTextField.topAnchor.constraint(equalTo: daysOfWeekStack.bottomAnchor, constant: 16),
            monthsTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            monthsTextField.widthAnchor.constraint(equalToConstant: 50),
            
            monthsLabel.centerYAnchor.constraint(equalTo: monthsTextField.centerYAnchor),
            monthsLabel.leadingAnchor.constraint(equalTo: monthsTextField.trailingAnchor, constant: 8),
            
            errorLabel.topAnchor.constraint(equalTo: monthsTextField.bottomAnchor, constant: 16),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        ])
    }
    
    private func setupDaysOfWeekStack() {
        daysOfWeekStack.axis = .horizontal
        daysOfWeekStack.distribution = .fillEqually
        let dayTitles = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
        
        for i in 0..<7 {
            let dayButton = UIButton(type: .system)
            dayButton.setTitle(dayTitles[i], for: .normal)
            dayButton.setTitleColor(.black, for: .normal)
            dayButton.addTarget(self, action: #selector(dayButtonTapped(_:)), for: .touchUpInside)
            dayButton.tag = i
            daysOfWeekStack.addArrangedSubview(dayButton)
        }
    }
    
    @objc private func dayButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        selectedDays[index].toggle()
        sender.backgroundColor = selectedDays[index] ? .systemBlue : .clear
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == timesPerDayTextField {
            if let text = textField.text, let value = Int(text), value > 10 {
                errorLabel.text = "Максимум 10, мы против насилия над собой"
                textField.text = "10"
            } else if textField.text?.isEmpty ?? true {
                textField.text = "1"
            }
        } else if textField == monthsTextField {
            if let text = textField.text, let value = Int(text), value > 125 {
                errorLabel.text = "Максимум 125, но мы восхищены горизонтом планирования — это больше 10 лет!"
                textField.text = "125"
            } else if textField.text?.isEmpty ?? true {
                textField.text = "1"
            }
        } else if textField == habitTextField, habitTextField.text?.isEmpty ?? true {
            errorLabel.text = "А что именно?"
        }
    }
    
    func validateFields() -> Bool {
        errorLabel.text = ""
        
        if habitTextField.text?.isEmpty ?? true {
            errorLabel.text = "А что именно?"
            return false
        }
        
        if !(selectedDays.contains(true)) {
            errorLabel.text = "Если не выбрать ни одного дня, в трекере нет смысла"
            return false
        }
        
        return true
    }
}
