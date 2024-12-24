//
//  AddNewHabitView.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 28/5/2567 BE.
//

import UIKit

class AddNewHabitButton: UIButton {
    
// MARK: - Delegate Protocol
    
   weak var delegate: NewHabitDelegate?
    
// MARK: - Parent view controller

    weak var parentFooterViewController: UIViewController?
    
// MARK: - UI Components
    
    func addNewHabitButton() {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = AppStyle.Colors.secondaryColor
        config.title = "Добавить привычку"
        config.image = UIImage(named: "Plus")
        config.imagePadding = 4
        config.imagePlacement = .leading
        config.titleAlignment = .center
        config.attributedTitle = AttributedString(
            "Добавить привычку",
            attributes: AttributeContainer([.font: AppStyle.Fonts.regularFont(size: 16)])
        )
        
        let button = UIButton(configuration: config)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.layer.borderWidth = AppStyle.Sizes.borderWidth
        button.layer.borderColor = AppStyle.Colors.borderColor.cgColor
        button.layer.cornerRadius = AppStyle.Sizes.cornerRadius
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(addNewHabitButtonTapped), for: .touchUpInside)
    }
    
// MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addNewHabitButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Action
    
    @objc private func addNewHabitButtonTapped() {
        guard let parentVC = parentFooterViewController as? NewHabitDelegate else {
            assertionFailure("parentFooterViewController не реализует NewHabitDelegate")
            return
        }
        let newHabitVC = NewHabitViewController()
        newHabitVC.modalPresentationStyle = .pageSheet
        newHabitVC.delegate = parentVC
        print("По кнопке открыт экран «Добавить привычку»")
        parentFooterViewController?.present(newHabitVC, animated: true, completion: nil)
    }
}

