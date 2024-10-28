//
//  NewHabitViewController.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 16/10/2567 BE.
//

import UIKit

class NewHabitViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - UI components
    
    private let clearView = UIView()
    
    private let emojiImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "EmojiNewHabit")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let promiseLabel: UILabel = {
        let label = UILabel()
        label.text = "Я обещаю себе"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var habitTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Делать что-то"
        textField.borderStyle = .roundedRect
        textField.delegate = self
        return textField
    }()
    
    private lazy var timesPerDayTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "1"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.delegate = self
        return textField
    }()
    
    private let timesPerDayLabel: UILabel = {
        let label = UILabel()
        label.text = "раз в день"
        return label
    }()
    
    private let daysOfWeekStack = UIStackView()
    
    private lazy var monthsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "1"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.delegate = self
        return textField
    }()
    
    private let monthsLabel: UILabel = {
        let label = UILabel()
        label.text = "месяц"
        return label
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private var selectedDays: [Bool] = Array(repeating: false, count: 7)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupComponents()
    }
    
    // MARK: - Set up components
    
    private func setupComponents() {
        view.addSubview(emojiImageView)
        view.addSubview(promiseLabel)
        
        setupDaysOfWeekStack()
        
        let stackView = UIStackView(arrangedSubviews: [
            habitTextField,
            timesPerDayTextField,
            timesPerDayLabel,
            daysOfWeekStack,
            monthsTextField,
            monthsLabel,
            errorLabel,
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        
        NSLayoutConstraint.activate([
            emojiImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 102),
            emojiImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emojiImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -321),
            
            promiseLabel.topAnchor.constraint(equalTo: emojiImageView.bottomAnchor, constant: 16),
            promiseLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            promiseLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            stackView.topAnchor.constraint(equalTo: promiseLabel.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
        ])
    }
    
    private func setupDaysOfWeekStack() {
        daysOfWeekStack.axis = .horizontal
        daysOfWeekStack.distribution = .fillEqually
        daysOfWeekStack.spacing = 4
        let dayTitles = ["пн", "вт", "ср", "чт", "пт", "сб", "вс"]
        
        for i in 0..<7 {
            let dayContainer = UIView()
            dayContainer.layer.cornerRadius = 18
            dayContainer.layer.borderWidth = 1
            dayContainer.layer.borderColor = UIColor.systemGray5.cgColor
            dayContainer.translatesAutoresizingMaskIntoConstraints = false
            dayContainer.widthAnchor.constraint(equalToConstant: 50).isActive = true
            dayContainer.heightAnchor.constraint(equalToConstant: 70).isActive = true
            
            let dayStack = UIStackView()
            dayStack.axis = .vertical
            dayStack.alignment = .center
            dayStack.spacing = 8
            dayStack.translatesAutoresizingMaskIntoConstraints = false
            dayContainer.addSubview(dayStack)
            
            let dayLabel = UILabel()
            dayLabel.text = dayTitles[i]
            dayLabel.font = UIFont.systemFont(ofSize: 14)
            dayLabel.textAlignment = .center
            
            let checkboxImageView = UIImageView()
            checkboxImageView.image = UIImage(named: "UncheckedCheckbox")
            checkboxImageView.contentMode = .scaleAspectFit
            checkboxImageView.isUserInteractionEnabled = true
            checkboxImageView.tag = i
            checkboxImageView.translatesAutoresizingMaskIntoConstraints = false
            checkboxImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(checkboxTapped(_:))))
            
            NSLayoutConstraint.activate([
                checkboxImageView.widthAnchor.constraint(equalToConstant: 24),
                checkboxImageView.heightAnchor.constraint(equalToConstant: 24)
            ])
            
            dayStack.addArrangedSubview(dayLabel)
            dayStack.addArrangedSubview(checkboxImageView)
            
            NSLayoutConstraint.activate([
                dayStack.centerXAnchor.constraint(equalTo: dayContainer.centerXAnchor),
                dayStack.centerYAnchor.constraint(equalTo: dayContainer.centerYAnchor)
            ])
            
            daysOfWeekStack.addArrangedSubview(dayContainer)
        }
    }
    
    // MARK: - Objc methods
    
    @objc private func checkboxTapped(_ sender: UITapGestureRecognizer) {
        guard let index = sender.view?.tag else { return }
        selectedDays[index].toggle()
        
        if let checkboxImageView = sender.view as? UIImageView {
            let imageName = selectedDays[index] ? "CheckedCheckbox" : "UncheckedCheckbox"
            checkboxImageView.image = UIImage(named: imageName)
        }
    }
    
    // MARK: - TextField methods
    
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
