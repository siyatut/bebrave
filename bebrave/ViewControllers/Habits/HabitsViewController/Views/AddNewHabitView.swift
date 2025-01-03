//
//  AddNewHabitView.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 28/5/2567 BE.
//

import UIKit

#warning("Если эта часть больше не является частью коллекции, значит можно убрать UICollectionReusableView и переписать её здесь и в HabitsViewController?")

class AddNewHabitView: UICollectionReusableView {
    
    // MARK: - Delegate Protocol
    
    weak var delegate: NewHabitDelegate?
    
    // MARK: - Parent view controller
    
    weak var parentFooterViewController: UIViewController?
    
    // MARK: - UI Components
    
    lazy var addNewHabitButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = AppStyle.Colors.secondaryColor
        config.title = "Добавить привычку"
        config.image = .plus
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
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup button
    
    private func setupButton() {
        addSubview(addNewHabitButton)
        NSLayoutConstraint.activate([
            addNewHabitButton.topAnchor.constraint(equalTo: topAnchor),
            addNewHabitButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            addNewHabitButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            addNewHabitButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
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

