//
//  NewHabitViewController.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 16/10/2567 BE.
//

import UIKit

class NewHabitViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - UI components top down
    
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
        textField.textAlignment = .left
        textField.delegate = self
        
        textField.layer.cornerRadius = 18
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray5.cgColor
        textField.clipsToBounds = true
        textField.backgroundColor = .systemBackground
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private lazy var timesPerDayTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "1"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.delegate = self
        
        textField.layer.cornerRadius = 18
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray5.cgColor
        textField.clipsToBounds = true
        textField.backgroundColor = .systemBackground
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private let timesPerDayLabel: UILabel = {
        let label = UILabel()
        label.text = "раз в день"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let daysOfWeekStack = UIStackView()
    
    private lazy var monthsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "1"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.delegate = self
        
        textField.layer.cornerRadius = 18
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray5.cgColor
        textField.clipsToBounds = true
        textField.backgroundColor = .systemBackground
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private let monthsLabel: UILabel = {
        let label = UILabel()
        label.text = "месяц"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var selectedDays: [Bool] = Array(repeating: false, count: 7)
    
    // MARK: - Button
    
    private let addNewHabitButton: UIButton = {
        let button = UIButton(type: .system)
            
        button.setTitle("Добавить привычку", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "PrimaryColor")
        
        if let plusImage = UIImage(named: "Plus") {
            button.setImage(plusImage, for: .normal)
        }
        
        button.tintColor = .white
        
        var config = UIButton.Configuration.plain()
        config.imagePadding = 4
        config.baseForegroundColor = .white
        button.configuration = config
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 18
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Error labels
    
    private let habitErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let timesPerDayErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let daysOfWeekErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let monthsErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupComponents()
    }
    
    // MARK: - Set up components
    
    private func setupComponents() {
        view.addSubview(emojiImageView)
        view.addSubview(promiseLabel)
        view.addSubview(addNewHabitButton)
        
        addNewHabitButton.addTarget(self, action: #selector(addNewHabitButtonTapped), for: .touchUpInside)
        setupDaysOfWeekStack()
        
        let timesPerDayStack = UIStackView(arrangedSubviews: [timesPerDayTextField, timesPerDayLabel])
        timesPerDayStack.axis = .horizontal
        timesPerDayStack.spacing = 8
        timesPerDayStack.alignment = .leading
        timesPerDayStack.translatesAutoresizingMaskIntoConstraints = false
        
        let monthsStack = UIStackView(arrangedSubviews: [monthsTextField, monthsLabel])
        monthsStack.axis = .horizontal
        monthsStack.spacing = 8
        monthsStack.alignment = .leading
        monthsStack.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [
            habitTextField,
            habitErrorLabel,
            timesPerDayStack,
            timesPerDayErrorLabel,
            daysOfWeekStack,
            daysOfWeekErrorLabel,
            monthsStack,
            monthsErrorLabel,
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            emojiImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            emojiImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emojiImageView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -321),
            emojiImageView.widthAnchor.constraint(equalToConstant: 40),
            emojiImageView.heightAnchor.constraint(equalToConstant: 40),
            
            promiseLabel.topAnchor.constraint(equalTo: emojiImageView.bottomAnchor, constant: 16),
            promiseLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            promiseLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -187),
            
            stackView.topAnchor.constraint(equalTo: promiseLabel.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: addNewHabitButton.topAnchor, constant: -20),
            
            habitTextField.heightAnchor.constraint(equalToConstant: 48),
            
            timesPerDayLabel.centerYAnchor.constraint(equalTo: timesPerDayTextField.centerYAnchor),
            monthsLabel.centerYAnchor.constraint(equalTo: monthsTextField.centerYAnchor),
            
            timesPerDayTextField.widthAnchor.constraint(equalToConstant: 57),
            timesPerDayTextField.heightAnchor.constraint(equalToConstant: 48),
            
            monthsTextField.widthAnchor.constraint(equalToConstant: 57),
            monthsTextField.heightAnchor.constraint(equalToConstant: 48),
            
            addNewHabitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -42),
            addNewHabitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            addNewHabitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            addNewHabitButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func setupDaysOfWeekStack() {
        daysOfWeekStack.axis = .horizontal
        daysOfWeekStack.distribution = .fillEqually
        daysOfWeekStack.spacing = 4
        daysOfWeekStack.translatesAutoresizingMaskIntoConstraints = false
        let dayTitles = ["пн", "вт", "ср", "чт", "пт", "сб", "вс"]
        
        for i in 0..<7 {
            let dayContainer = UIView()
            dayContainer.layer.cornerRadius = 18
            dayContainer.layer.borderWidth = 1
            dayContainer.layer.borderColor = UIColor.systemGray5.cgColor
            dayContainer.translatesAutoresizingMaskIntoConstraints = false
            dayContainer.widthAnchor.constraint(equalToConstant: 49).isActive = true
            dayContainer.heightAnchor.constraint(equalToConstant: 71).isActive = true
            
            let dayStack = UIStackView()
            dayStack.axis = .vertical
            dayStack.alignment = .center
            dayStack.spacing = 8
            dayStack.translatesAutoresizingMaskIntoConstraints = false
            dayContainer.addSubview(dayStack)
            
            let dayLabel = UILabel()
            dayLabel.text = dayTitles[i]
            dayLabel.font = UIFont.systemFont(ofSize: 16)
            dayLabel.textAlignment = .center
            dayLabel.translatesAutoresizingMaskIntoConstraints = false
            
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
    
    @objc private func addNewHabitButtonTapped() {
    
        if validateFields() {
            print("Сохраняем привычку")
            // Здесь добавить логику для сохранения привычки
        } else {
            print("Ошибка в заполнении формы")
        }
    }
    
   // MARK: - TextField methods

    func validateFields() -> Bool {
        var isValid = true
        
        resetErrorStates()
        
        if habitTextField.text?.isEmpty ?? true {
            habitErrorLabel.text = "А что именно?"
            habitErrorLabel.isHidden = false
            habitTextField.layer.borderColor = UIColor.red.cgColor
            isValid = false
        }
        
        if let text = timesPerDayTextField.text, text.isEmpty {
            timesPerDayTextField.text = "1"
        } else if let value = Int(timesPerDayTextField.text ?? ""), value > 10 {
            timesPerDayErrorLabel.text = "Максимум 10, мы против насилия над собой"
            timesPerDayErrorLabel.isHidden = false
            timesPerDayTextField.layer.borderColor = UIColor.red.cgColor
            isValid = false
        }
        
        if !selectedDays.contains(true) {
            daysOfWeekErrorLabel.text = "Если не выбрать ни одного дня, в трекере нет смысла"
            daysOfWeekErrorLabel.isHidden = false
            highlightDaysOfWeekStack(with: .red)
            isValid = false
        }
        
        if let text = monthsTextField.text, text.isEmpty {
            monthsTextField.text = "1"
        } else if let value = Int(monthsTextField.text ?? ""), value > 125 {
            monthsErrorLabel.text = "Максимум 125, но мы восхищены горизонтом планирования — это больше 10 лет!"
            monthsErrorLabel.isHidden = false
            monthsTextField.layer.borderColor = UIColor.red.cgColor
            isValid = false
        }
        return isValid
    }
    
    private func resetErrorStates() {
        habitErrorLabel.isHidden = true
        timesPerDayErrorLabel.isHidden = true
        daysOfWeekErrorLabel.isHidden = true
        monthsErrorLabel.isHidden = true
        
        habitTextField.layer.borderColor = UIColor.systemGray5.cgColor
        timesPerDayTextField.layer.borderColor = UIColor.systemGray5.cgColor
        monthsTextField.layer.borderColor = UIColor.systemGray5.cgColor
        
        highlightDaysOfWeekStack(with: UIColor.systemGray5)
    }
    
    private func highlightDaysOfWeekStack(with color: UIColor) {
        for view in daysOfWeekStack.arrangedSubviews {
            view.layer.borderColor = color.cgColor
        }
    }
}
