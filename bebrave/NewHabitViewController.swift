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
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
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
        
        let plusImage = UIImage(named: "Plus")
        let plusImageGray = UIImage(named: "Plus")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        
        button.setImage(plusImage, for: .normal)
        button.setImage(plusImageGray, for: .disabled)
        
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
    
    private var hasAttemptedSave = false
    
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
        
        addNewHabitButton.addTarget(self, action: #selector(addNewHabitButtonTapped), for: .touchUpInside)
        updateButtonState()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Button state update
    
    private func updateButtonState() {
        let isFormValid = validateFields(showErrors: hasAttemptedSave)
        addNewHabitButton.isEnabled = isFormValid
        addNewHabitButton.backgroundColor = isFormValid ? UIColor(named: "PrimaryColor") : .systemGray2
        addNewHabitButton.setTitleColor(.white, for: .disabled)
    }
    
    // MARK: - Set up components
    
    private func setupComponents() {
        setupDaysOfWeekStack()
        
        let timesPerDayStack = UIStackView(arrangedSubviews: [timesPerDayTextField, timesPerDayLabel])
        timesPerDayStack.axis = .horizontal
        timesPerDayStack.spacing = 8
        timesPerDayStack.alignment = .leading
        timesPerDayStack.distribution = .fillProportionally
        timesPerDayStack.translatesAutoresizingMaskIntoConstraints = false
        
        let monthsStack = UIStackView(arrangedSubviews: [monthsTextField, monthsLabel])
        monthsStack.axis = .horizontal
        monthsStack.spacing = 8
        monthsStack.alignment = .leading
        monthsStack.distribution = .fillProportionally
        monthsStack.translatesAutoresizingMaskIntoConstraints = false
        
        let labels = [promiseLabel, habitErrorLabel, timesPerDayErrorLabel, daysOfWeekErrorLabel, monthsErrorLabel]
        let stacks = [timesPerDayStack, daysOfWeekStack, monthsStack]
        
        for l in labels {
            view.addSubview(l)
        }
        
        for s in stacks {
            view.addSubview(s)
        }
        
        view.addSubview(emojiImageView)
        view.addSubview(addNewHabitButton)
        view.addSubview(habitTextField)
        
        NSLayoutConstraint.activate([
            emojiImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            emojiImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emojiImageView.widthAnchor.constraint(equalToConstant: 40),
            emojiImageView.heightAnchor.constraint(equalToConstant: 40),
            
            promiseLabel.topAnchor.constraint(equalTo: emojiImageView.bottomAnchor, constant: 16),
            promiseLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            promiseLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -187),
            
            habitTextField.topAnchor.constraint(equalTo: promiseLabel.bottomAnchor, constant: 16),
            habitTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            habitTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            habitTextField.heightAnchor.constraint(equalToConstant: 48),
            
            habitErrorLabel.topAnchor.constraint(equalTo: habitTextField.bottomAnchor, constant: 4),
            habitErrorLabel.leadingAnchor.constraint(equalTo: habitTextField.leadingAnchor, constant: 16),
            habitErrorLabel.trailingAnchor.constraint(equalTo: habitTextField.trailingAnchor),
            
            timesPerDayStack.topAnchor.constraint(equalTo: habitErrorLabel.bottomAnchor, constant: 16),
            timesPerDayStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            timesPerDayStack.trailingAnchor.constraint(equalTo: habitTextField.trailingAnchor),
            
            timesPerDayErrorLabel.topAnchor.constraint(equalTo: timesPerDayStack.bottomAnchor, constant: 4),
            timesPerDayErrorLabel.leadingAnchor.constraint(equalTo: timesPerDayStack.leadingAnchor, constant: 16),
            timesPerDayErrorLabel.trailingAnchor.constraint(equalTo: timesPerDayStack.trailingAnchor),
            
            daysOfWeekStack.topAnchor.constraint(equalTo: timesPerDayErrorLabel.bottomAnchor, constant: 16),
            daysOfWeekStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            daysOfWeekStack.trailingAnchor.constraint(equalTo: habitTextField.trailingAnchor),
            
            daysOfWeekErrorLabel.topAnchor.constraint(equalTo: daysOfWeekStack.bottomAnchor, constant: 4),
            daysOfWeekErrorLabel.leadingAnchor.constraint(equalTo: daysOfWeekStack.leadingAnchor, constant: 16),
            daysOfWeekErrorLabel.trailingAnchor.constraint(equalTo: daysOfWeekStack.trailingAnchor),
            
            monthsStack.topAnchor.constraint(equalTo: daysOfWeekErrorLabel.bottomAnchor, constant: 16),
            monthsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            monthsStack.trailingAnchor.constraint(equalTo: habitTextField.trailingAnchor),
            
            monthsErrorLabel.topAnchor.constraint(equalTo: monthsStack.bottomAnchor, constant: 4),
            monthsErrorLabel.leadingAnchor.constraint(equalTo: monthsStack.leadingAnchor, constant: 16),
            monthsErrorLabel.trailingAnchor.constraint(equalTo: monthsStack.trailingAnchor),
            
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
    
    // MARK: - Set up daysOfWeekStack
    
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
            
            dayStack.addArrangedSubview(dayLabel)
            dayStack.addArrangedSubview(checkboxImageView)
            
            NSLayoutConstraint.activate([
                dayStack.centerXAnchor.constraint(equalTo: dayContainer.centerXAnchor),
                dayStack.centerYAnchor.constraint(equalTo: dayContainer.centerYAnchor),
                dayContainer.heightAnchor.constraint(equalToConstant: 71),
                checkboxImageView.widthAnchor.constraint(equalToConstant: 24),
                checkboxImageView.heightAnchor.constraint(equalToConstant: 24)
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
        hasAttemptedSave = true
        let isFormValid = validateFields(showErrors: true)
        
        if isFormValid {
            print("Сохраняем привычку")
            // Здесь будет логика сохранения привычки
        } else {
            print("Ошибка в заполнении формы")
        }
        updateButtonState()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Reset error states
    
    func validateFields(showErrors: Bool = false) -> Bool {
        var isValid = true
        resetErrorStates()
        
        if habitTextField.text?.isEmpty ?? true {
            isValid = false
            if showErrors {
                habitErrorLabel.text = "А что именно?"
                habitErrorLabel.isHidden = false
                habitTextField.layer.borderColor = UIColor.red.cgColor
            }
        }
        
        if let value = Int(timesPerDayTextField.text ?? ""), !(1...10).contains(value) {
            isValid = false
            if showErrors {
                timesPerDayErrorLabel.text = "Максимум 10, мы против насилия над собой"
                timesPerDayErrorLabel.isHidden = false
                timesPerDayTextField.layer.borderColor = UIColor.red.cgColor
            }
        }
        
        if !selectedDays.contains(true) {
            isValid = false
            if showErrors {
                daysOfWeekErrorLabel.text = "Если не выбрать ни одного дня, в трекере нет смысла"
                daysOfWeekErrorLabel.isHidden = false
                highlightDaysOfWeekStack(with: .red)
            }
        }
        
        if let value = Int(monthsTextField.text ?? ""), !(1...125).contains(value) {
            isValid = false
            if showErrors {
                monthsErrorLabel.text = "Максимум 125, но мы восхищены горизонтом\nпланирования — это больше 10 лет!"
                monthsErrorLabel.isHidden = false
                monthsTextField.layer.borderColor = UIColor.red.cgColor
            }
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
    
    // MARK: - Text field delegate (сhecking and updating the button state and logic for changing label's text on values ​​in text fields)
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateButtonState()
        
        if textField == timesPerDayTextField {
            if let text = textField.text, let value = Int(text), (1...10).contains(value) {
                timesPerDayLabel.text = dayText(for: value)
                timesPerDayErrorLabel.isHidden = true
                timesPerDayTextField.layer.borderColor = UIColor.systemGray5.cgColor
            } else {
                timesPerDayLabel.text = "раз в день"
                timesPerDayErrorLabel.text = "Максимум 10, мы против насилия над собой"
                timesPerDayErrorLabel.isHidden = false
                timesPerDayTextField.layer.borderColor = UIColor.red.cgColor
            }
        } else if textField == monthsTextField {
            if let text = textField.text, let value = Int(text), (1...125).contains(value) {
                monthsLabel.text = monthText(for: value)
                monthsErrorLabel.isHidden = true
                monthsTextField.layer.borderColor = UIColor.systemGray5.cgColor
            } else {
                monthsLabel.text = "месяц"
                monthsErrorLabel.text = "Максимум 125, но мы восхищены горизонтом\nпланирования — это больше 10 лет!"
                monthsErrorLabel.isHidden = false
                monthsTextField.layer.borderColor = UIColor.red.cgColor
            }
        }
    }
    
    // MARK: - Change's method for the words "day" and "month"
    
    private func dayText(for value: Int) -> String {
        switch value {
        case 2...4: return "раза в день"
        default: return "раз в день"
        }
    }
    
    private func monthText(for value: Int) -> String {
        guard (1...125).contains(value) else { return "месяц" }
        
        let lastDigit = value % 10
        let lastTwoDigits = value % 100
        
        switch lastDigit {
        case 1 where lastTwoDigits != 11:
            return "месяц"
        case 2...4 where !(12...14).contains(lastTwoDigits):
            return "месяца"
        default:
            return "месяцев"
        }
    }
}
