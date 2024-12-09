//
//  AddNewHabitView.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 28/5/2567 BE.
//

import UIKit

class AddNewHabitView: UICollectionReusableView {
    
// MARK: - Parent view controller
    
    weak var delegate: NewHabitDelegate?
    
// MARK: - UI Components
    
    weak var parentFooterViewController: UIViewController?
    
    private let view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let addNewHabitLabel: UILabel = {
        let label = UILabel()
        label.text = "Добавить привычку"
        label.textColor = AppStyle.Colors.secondaryColor
        label.font = AppStyle.Fonts.regularFont(size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let plus: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Plus")
        view.tintColor = AppStyle.Colors.secondaryColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let outlineBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = AppStyle.Sizes.borderWidth
        view.layer.borderColor = AppStyle.Colors.borderColor.cgColor
        view.layer.cornerRadius = AppStyle.Sizes.cornerRadius
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
// MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Set up components
    
    func setupComponents() {
        addSubview(outlineBackgroundView)
        addSubview(view)
        addSubview(button)
        view.addSubview(addNewHabitLabel)
        view.addSubview(plus)
    
        addNewHabitLabel.setContentHuggingPriority(.defaultHigh + 1, for: .horizontal)
        button.addTarget(self, action: #selector(addNewHabitButtonTapped), for: .touchUpInside)
       
        NSLayoutConstraint.activate([
            outlineBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            outlineBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            outlineBackgroundView.topAnchor.constraint(equalTo: topAnchor),
            outlineBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
            view.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            addNewHabitLabel.topAnchor.constraint(equalTo: view.topAnchor),
            addNewHabitLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            addNewHabitLabel.leadingAnchor.constraint(equalTo: plus.trailingAnchor, constant: 4),
            addNewHabitLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            plus.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            plus.topAnchor.constraint(equalTo: addNewHabitLabel.topAnchor),
            plus.bottomAnchor.constraint(equalTo: addNewHabitLabel.bottomAnchor),
            
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.topAnchor.constraint(equalTo: topAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
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

