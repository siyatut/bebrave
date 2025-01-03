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
    
    var hasAttemptedSave = false
    
    func updateButtonState() {
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
    
    
    func animateLayoutChanges(duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut) {
            self.view.layoutIfNeeded()
        }
    }
}
