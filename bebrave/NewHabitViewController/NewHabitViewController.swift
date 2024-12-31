//
//  NewHabitViewController.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 16/10/2567 BE.
//

import UIKit

class NewHabitViewController: UIViewController {
    
    // MARK: - Delegate
    
    weak var delegate: NewHabitDelegate?
    
    // MARK: - UI components top down
    
    let emojiImageView: UIImageView = {
        let view = UIImageView()
        view.image = .emojiNewHabit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var habitTextField: UITextField = {
        let textField = UITextField.styled(placeholder: "Делать что-то", keyboardType: .default)
        addPaddingToTextField(textField, paddingWidth: AppStyle.Sizes.padding)
        return textField
    }()
    
    lazy var promiseLabel = UILabel.styled(text: "Я обещаю себе", fontSize: 24, isBold: true)
    lazy var timesPerDayTextField = UITextField.styled(placeholder: "1", alignment: .center)
    lazy var timesPerDayLabel = UILabel.styled(text: "раз в день")
    
    let daysOfWeekStack = UIStackView()
    var selectedDays: [Bool] = Array(repeating: true, count: 7)
    lazy var monthsTextField = UITextField.styled(placeholder: "1", alignment: .center)
    lazy var monthsLabel = UILabel.styled(text: "месяц")
    
    // MARK: - Helper methods for text field
    
    private func addPaddingToTextField(_ textField: UITextField, paddingWidth: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: paddingWidth, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
    
    // MARK: - Error labels
    
    lazy var habitErrorLabel = UILabel.styled(text: "", fontSize: 12, color: AppStyle.Colors.errorColor, numberOfLines: 0, isHidden: true)
    lazy var timesPerDayErrorLabel = UILabel.styled(text: "", fontSize: 12, color: AppStyle.Colors.errorColor, numberOfLines: 0, isHidden: true)
    lazy var daysOfWeekErrorLabel = UILabel.styled(text: "", fontSize: 12, color: AppStyle.Colors.errorColor, numberOfLines: 0, isHidden: true)
    lazy var monthsErrorLabel = UILabel.styled(text: "", fontSize: 12, color: AppStyle.Colors.errorColor, numberOfLines: 0, isHidden: true)
    
    // MARK: - Error label's height
    
    var habitErrorLabelHeightConstraint: NSLayoutConstraint!
    var timesPerDayErrorLabelHeightConstraint: NSLayoutConstraint!
    var daysOfWeekErrorLabelHeightConstraint: NSLayoutConstraint!
    
    func setupErrorLabelConstraints() {
        habitErrorLabelHeightConstraint = habitErrorLabel.heightAnchor.constraint(equalToConstant: 0)
        timesPerDayErrorLabelHeightConstraint = timesPerDayErrorLabel.heightAnchor.constraint(equalToConstant: 0)
        daysOfWeekErrorLabelHeightConstraint = daysOfWeekErrorLabel.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            habitErrorLabelHeightConstraint,
            timesPerDayErrorLabelHeightConstraint,
            daysOfWeekErrorLabelHeightConstraint,
        ])
    }
    
    // MARK: - Button
    
    lazy var addNewHabitButton: UIButton = {
        let button = UIButton(type: .system)
        
        var config = UIButton.Configuration.filled()
        config.title = "Добавить привычку"
        config.baseForegroundColor = .white
        config.image = .plus
        config.imagePadding = 4
        config.cornerStyle = .capsule
        button.configuration = config
        
        button.configurationUpdateHandler = { button in
            var updatedConfig = button.configuration
            updatedConfig?.background.backgroundColor = button.isEnabled
            ? AppStyle.Colors.primaryColor
            : AppStyle.Colors.disabledButtonColor
            button.configuration = updatedConfig
        }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addNewHabitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Button state update
    
    private var hasAttemptedSave = false
    
    private func updateButtonState() {
        let isValid = validateFields(showErrors: hasAttemptedSave)
        addNewHabitButton.isEnabled = isValid
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppStyle.Colors.backgroundColor
        setupComponents()
        setupErrorLabelConstraints()
        delegateTextFields()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Utility methods
    
    func addSubviews(_ views: [UIView]) {
        views.forEach { view.addSubview($0) }
    }
    
    // MARK: - Interact with button and checkbox
    
    @objc func checkboxTapped(_ sender: UITapGestureRecognizer) {
        guard let index = sender.view?.tag else { return }
        selectedDays[index].toggle()
        
        if let checkboxImageView = sender.view as? UIImageView {
            let imageName = selectedDays[index] ? "UncheckedCheckbox" : "CheckedCheckbox"
            checkboxImageView.image = UIImage(named: imageName)
        }
    }
    
    @objc private func addNewHabitButtonTapped() {
        hasAttemptedSave = true
        let isValid = validateFields(showErrors: true)
        
        guard isValid else {
            print("После нажатия на кнопку. Есть ошибки. Кнопка недоступна")
            updateButtonState()
            return
        }
        guard let title = habitTextField.text,
              let frequencyText = timesPerDayTextField.text,
              let frequency = Int(frequencyText) else {
            print("Не удалось получить данные для создания привычки.")
            updateButtonState()
            return
        }
        let newHabit = Habit(
            id: UUID(),
            title: title,
            frequency: frequency,
            progress: [:] 
        )
        UserDefaultsManager.shared.addHabit(newHabit)
        delegate?.didAddNewHabit(newHabit)
        print("Привычка сохранена: \(newHabit.title)")
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
        hasAttemptedSave = true
        let isValid = validateFields(showErrors: true)
        
        guard isValid else {
            print("После нажатия на экран есть ошибки. Кнопка недоступна")
            updateButtonState()
            return
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
                habitTextField.layer.borderColor = AppStyle.Colors.errorColor.cgColor
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
                timesPerDayTextField.layer.borderColor = AppStyle.Colors.errorColor.cgColor
                timesPerDayErrorLabelHeightConstraint.constant = 15
            }
        }
        
        if !selectedDays.contains(true) {
            isValid = false
            if showErrors {
                daysOfWeekErrorLabel.text = "Если не выбрать ни одного дня, в трекере нет смысла"
                daysOfWeekErrorLabel.isHidden = false
                daysOfWeekErrorLabelHeightConstraint.constant = 15
                highlightDaysOfWeekStack(with: AppStyle.Colors.errorColor)
            }
        } else {
            daysOfWeekErrorLabel.isHidden = true
            daysOfWeekErrorLabelHeightConstraint.constant = 0
            highlightDaysOfWeekStack(with: AppStyle.Colors.borderColor)
        }
        
        if let text = monthsTextField.text, text.isEmpty {
            monthsTextField.text = "1"
        } else if let value = Int(monthsTextField.text ?? ""), value > 125 {
            isValid = false
            if showErrors {
                monthsErrorLabel.text = "Максимум 125, но мы восхищены горизонтом\nпланирования — это больше 10 лет!"
                monthsErrorLabel.isHidden = false
                monthsTextField.layer.borderColor = AppStyle.Colors.errorColor.cgColor
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
        
        habitTextField.layer.borderColor = AppStyle.Colors.borderColor.cgColor
        timesPerDayTextField.layer.borderColor = AppStyle.Colors.borderColor.cgColor
        monthsTextField.layer.borderColor = AppStyle.Colors.borderColor.cgColor
        highlightDaysOfWeekStack(with: AppStyle.Colors.borderColor)
        
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
            view.layer.borderWidth = AppStyle.Sizes.borderWidth
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

// MARK: - UITextFieldDelegate

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
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == habitTextField {
            if let currentText = textField.text {
                let formattedText = currentText
                    .trimmingCharacters(in: .whitespaces)
                    .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
                textField.text = formattedText
            }
        }
        updateButtonState()
        return true
    }
}
