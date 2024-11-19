//
//  NewHabitViewController.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 16/10/2567 BE.
//

import UIKit

#warning("Проверить, как можно упростить код. Есть ли вещи, которые можно убрать")


class NewHabitViewController: UIViewController {
    
    // MARK: Methods for text field
    
    private func addPaddingToTextField(_ textField: UITextField, paddingWidth: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: paddingWidth, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
    
    private func delegeteTextFields() {
        habitTextField.delegate = self
        timesPerDayTextField.delegate = self
        monthsTextField.delegate = self
    }
    
    // MARK: - UI components top down
    
    private let emojiImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "EmojiNewHabit")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var habitTextField: UITextField = {
        let textField = UITextField.styled(placeholder: "Делать что-то")
        textField.keyboardType = .default
        addPaddingToTextField(textField, paddingWidth: 12)
        return textField
    }()
    
    private lazy var promiseLabel = UILabel.styled(text: "Я обещаю себе", fontSize: 24, isBold: true)
    private lazy var timesPerDayTextField = UITextField.styled(placeholder: "1", alignment: .center)
    private lazy var timesPerDayLabel = UILabel.styled(text: "раз в день")
    
    private let daysOfWeekStack = UIStackView()
    private var selectedDays: [Bool] = Array(repeating: true, count: 7)
    private lazy var monthsTextField = UITextField.styled(placeholder: "1", alignment: .center)
    private lazy var monthsLabel = UILabel.styled(text: "месяц")
    
    // MARK: - Error labels
    
    private lazy var habitErrorLabel = UILabel.styled(text: "", fontSize: 12, color: .red, numberOfLines: 0, isHidden: true)
    private lazy var timesPerDayErrorLabel = UILabel.styled(text: "", fontSize: 12, color: .red, numberOfLines: 0, isHidden: true)
    private lazy var daysOfWeekErrorLabel = UILabel.styled(text: "", fontSize: 12, color: .red, numberOfLines: 0, isHidden: true)
    private lazy var monthsErrorLabel = UILabel.styled(text: "", fontSize: 12, color: .red, numberOfLines: 0, isHidden: true)
    
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
    
    // MARK: - Button state update
    
    private func updateButtonState() {
        addNewHabitButton.isEnabled = validateFields(showErrors: hasAttemptedSave)
        addNewHabitButton.backgroundColor = addNewHabitButton.isEnabled ? UIColor(named: "PrimaryColor") : .systemGray2
        addNewHabitButton.setTitleColor(.white, for: .disabled)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupComponents()
        setupErrorLabelConstraints()
        delegeteTextFields()
        addNewHabitButton.addTarget(self, action: #selector(addNewHabitButtonTapped), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Error label's height
    
    private var habitErrorLabelHeightConstraint: NSLayoutConstraint!
    private var timesPerDayErrorLabelHeightConstraint: NSLayoutConstraint!
    private var daysOfWeekErrorLabelHeightConstraint: NSLayoutConstraint!
   
    private func setupErrorLabelConstraints() {
        habitErrorLabelHeightConstraint = habitErrorLabel.heightAnchor.constraint(equalToConstant: 0)
        timesPerDayErrorLabelHeightConstraint = timesPerDayErrorLabel.heightAnchor.constraint(equalToConstant: 0)
        daysOfWeekErrorLabelHeightConstraint = daysOfWeekErrorLabel.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            habitErrorLabelHeightConstraint,
            timesPerDayErrorLabelHeightConstraint,
            daysOfWeekErrorLabelHeightConstraint,
        ])
    }
    
    // MARK: - Set up UI components
    
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
            checkboxImageView.image = UIImage(named: selectedDays[i] ? "CheckedCheckbox" : "UncheckedCheckbox")
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
    
    // MARK: - Interacting with button and checkbox
    
    private func validateAndShowErrorsIfNeeded() -> Bool {
        return validateFields(showErrors: true)
    }
    
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
        if validateAndShowErrorsIfNeeded() {
            print("Сохраняем привычку")
            // Здесь будет логика сохранения привычки
        } else {
          print("После нажатия на кнопку. Есть ошибки. Кнопка недоступна")
        }
        updateButtonState()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
        if validateAndShowErrorsIfNeeded() {
            updateButtonState()
        } else {
            print("После скрытия клавиатуры. Есть ошибки. Кнопка недоступна")
        }
    }
    
    // MARK: - Animate hiding labels
    
    private func animateLayoutChanges(duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Reset error states
    
    func validateFields(showErrors: Bool = false) -> Bool {
        var isValid = true
        resetErrorStates(animated: true)
        
        if habitTextField.text?.isEmpty ?? true {
            isValid = false
            if showErrors {
                habitErrorLabel.text = "А что именно?"
                habitErrorLabel.isHidden = false
                habitTextField.layer.borderColor = UIColor.red.cgColor
                habitErrorLabelHeightConstraint.constant = 15
            }
        }
        
        if let text = timesPerDayTextField.text, text.isEmpty {
            timesPerDayTextField.text = "1"
        } else if let value = Int(timesPerDayTextField.text ?? ""), value > 10 {
            isValid = false
            if showErrors {
                timesPerDayErrorLabel.text = "Максимум 10, мы против насилия над собой"
                timesPerDayErrorLabel.isHidden = false
                timesPerDayTextField.layer.borderColor = UIColor.red.cgColor
                timesPerDayErrorLabelHeightConstraint.constant = 15
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
        
        if let text = monthsTextField.text, text.isEmpty {
            monthsTextField.text = "1"
        } else if let value = Int(monthsTextField.text ?? ""), value > 125 {
            isValid = false
            if showErrors {
                monthsErrorLabel.text = "Максимум 125, но мы восхищены горизонтом\nпланирования — это больше 10 лет!"
                monthsErrorLabel.isHidden = false
                monthsTextField.layer.borderColor = UIColor.red.cgColor
            }
        }
        
        animateLayoutChanges()
        return isValid
    }
    
    private func resetErrorStates(animated: Bool = true) {
        habitErrorLabel.isHidden = true
        timesPerDayErrorLabel.isHidden = true
        daysOfWeekErrorLabel.isHidden = true
        monthsErrorLabel.isHidden = true
        
        habitTextField.layer.borderColor = UIColor.systemGray5.cgColor
        timesPerDayTextField.layer.borderColor = UIColor.systemGray5.cgColor
        monthsTextField.layer.borderColor = UIColor.systemGray5.cgColor
        highlightDaysOfWeekStack(with: UIColor.systemGray5)
        
        habitErrorLabelHeightConstraint.constant = 0
        timesPerDayErrorLabelHeightConstraint.constant = 0
        daysOfWeekErrorLabelHeightConstraint.constant = 0
        
        if animated {
            animateLayoutChanges()
        } else {
            view.layoutIfNeeded()
        }
    }
    
    private func highlightDaysOfWeekStack(with color: UIColor) {
        for view in daysOfWeekStack.arrangedSubviews {
            view.layer.borderColor = color.cgColor
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
        guard (1...125).contains(value) else { return "месяцев" }
        
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

extension NewHabitViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if textField == timesPerDayTextField {
            if let text = textField.text, let value = Int(text), (1...10).contains(value) {
                timesPerDayLabel.text = dayText(for: value)
            } else {
                timesPerDayLabel.text = "раз в день"
            }
        }
    
        if textField == monthsTextField {
            if let text = textField.text, let value = Int(text), (1...125).contains(value) {
                monthsLabel.text = monthText(for: value)
            } else {
                monthsLabel.text = "месяцев"
            }
        }
    }
}

extension UILabel {
    static func styled(text: String, fontSize: CGFloat = 16, color: UIColor = .label, isBold: Bool = false, alignment: NSTextAlignment = .left, numberOfLines: Int = 1, isHidden: Bool = false) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = color
        label.font = isBold ? .boldSystemFont(ofSize: fontSize) : .systemFont(ofSize: fontSize)
        label.textAlignment = alignment
        label.numberOfLines = numberOfLines
        label.isHidden = isHidden
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

extension UITextField {
    static func styled(placeholder: String, keyboardType: UIKeyboardType = .numberPad, alignment: NSTextAlignment = .left) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.keyboardType = keyboardType
        textField.textAlignment = alignment
        textField.layer.cornerRadius = 18
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray5.cgColor
        textField.clipsToBounds = true
        textField.backgroundColor = .systemBackground
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
}
