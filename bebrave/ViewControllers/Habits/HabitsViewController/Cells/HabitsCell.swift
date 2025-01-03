//
//  HabitsCollectionViewCell.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 10/4/2567 BE.
//

import UIKit

class HabitsCell: UICollectionViewCell {
    
    private var panGesture: UIPanGestureRecognizer!
    private var originalCenter: CGPoint = .zero
    
    // МARK: - UI components for swipe
    
    private lazy var deleteHabitIcon = createImageView(imageName: "DeleteHabit", tintColor: .red, alpha: 0)
    private lazy var changeHabitIcon = createImageView(imageName: "ChangeHabit", tintColor: AppStyle.Colors.secondaryColor, alpha: 0)
    private lazy var deleteHabitLabel = createLabel(textColor: .red, font: AppStyle.Fonts.regularFont(size: 10), alpha: 0)
    private lazy var changeHabitLabel = createLabel(textColor: AppStyle.Colors.secondaryColor, font: AppStyle.Fonts.regularFont(size: 10), alpha: 0)
    
    // MARK: - UI components
    
    private lazy var habitsName = createLabel(textColor: .label, font: AppStyle.Fonts.regularFont(size: 16))
    private lazy var percentDone = createLabel(textColor: .secondaryLabel, font: AppStyle.Fonts.regularFont(size: 16))
    private lazy var habitsCount = createLabel(textColor: .secondaryLabel, font: AppStyle.Fonts.regularFont(size: 16))
    private lazy var starDivider = createImageView(imageName: "StarDivider", tintColor: AppStyle.Colors.secondaryColor)
    private lazy var checkbox = createImageView(imageName: "UncheckedCheckbox", tintColor: AppStyle.Colors.borderColor)
    
    private let horizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponents()
        setupTapGesture()
        setupPanGesture()
        setupIcons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        deleteHabitIcon.alpha = 0
        changeHabitIcon.alpha = 0
        deleteHabitLabel.alpha = 0
        changeHabitIcon.alpha = 0
    }
    
    // MARK: - Gesture methods
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false
        contentView.addGestureRecognizer(tapGesture)
    }
    
    private func setupPanGesture() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.cancelsTouchesInView = false
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        switch gesture.state {
        case .began:
            originalCenter = center
            
        case .changed:
            center.x = originalCenter.x + translation.x
            
            if translation.x < 0 {
                deleteHabitIcon.alpha = min(1, abs(translation.x) / 100)
                deleteHabitLabel.alpha = 1
                changeHabitIcon.alpha = 0
                changeHabitLabel.alpha = 0
            } else {
                changeHabitIcon.alpha = min(1, translation.x / 100)
                changeHabitLabel.alpha = 1
                deleteHabitIcon.alpha = 0
                deleteHabitLabel.alpha = 0
            }
            
        case .ended:
            if translation.x < -100 {
                UIView.animate(withDuration: 0.2) {
                    self.center.x = self.originalCenter.x - self.bounds.width
                } completion: { _ in
                    NotificationCenter.default.post(name: Notification.Name("DeleteHabit"), object: self)
                }
            } else if translation.x > 100 {
                NotificationCenter.default.post(name: Notification.Name("ChangeHabit"), object: self)
                resetPosition()
            } else {
                resetPosition()
            }
            
        default:
            break
        }
    }

    private func resetPosition() {
        UIView.animate(withDuration: 0.3) {
            self.center = self.originalCenter
            self.deleteHabitIcon.alpha = 0
            self.changeHabitIcon.alpha = 0
            self.deleteHabitLabel.alpha = 0
            self.changeHabitLabel.alpha = 0
        }
    }
    
    @objc private func handleTap() {
        print("Cell tapped!")
    }
    
    // MARK: - Set up components
    
    private func setupIcons() {
        addSubview(deleteHabitIcon)
        addSubview(changeHabitIcon)
        addSubview(deleteHabitLabel)
        addSubview(changeHabitLabel)
        
        deleteHabitLabel.text = "Удалить"
        changeHabitLabel.text = "Изменить"
        
        NSLayoutConstraint.activate([
            deleteHabitIcon.topAnchor.constraint(equalTo: topAnchor, constant: 13),
            changeHabitIcon.topAnchor.constraint(equalTo: topAnchor, constant: 13),
        
            deleteHabitIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 30),
            changeHabitIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -30),
            deleteHabitLabel.centerXAnchor.constraint(equalTo: deleteHabitIcon.centerXAnchor),
            changeHabitLabel.centerXAnchor.constraint(equalTo: changeHabitIcon.centerXAnchor),
            
            deleteHabitIcon.heightAnchor.constraint(equalToConstant: 20),
            deleteHabitIcon.widthAnchor.constraint(equalToConstant: 20),
            deleteHabitLabel.topAnchor.constraint(equalTo: deleteHabitIcon.bottomAnchor, constant: 2),
            
            changeHabitIcon.heightAnchor.constraint(equalToConstant: 22),
            changeHabitIcon.widthAnchor.constraint(equalToConstant: 22),
            changeHabitLabel.topAnchor.constraint(equalTo: changeHabitIcon.bottomAnchor, constant: 2)
        ])
    }
    
    private func addSubviewsToStackView(_ stackView: UIStackView, views: [UIView]) {
        views.forEach { stackView.addArrangedSubview($0) }
    }
    
    private func setupComponents() {
        addSubviewsToStackView(horizontalStackView, views: [habitsName, starDivider, habitsCount])
        
        contentView.addSubview(horizontalStackView)
        contentView.addSubview(percentDone)
        contentView.addSubview(checkbox)
        
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            horizontalStackView.trailingAnchor.constraint(lessThanOrEqualTo: checkbox.leadingAnchor, constant: 106),
            
            percentDone.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 4),
            percentDone.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            percentDone.leadingAnchor.constraint(equalTo: horizontalStackView.leadingAnchor),
            percentDone.trailingAnchor.constraint(lessThanOrEqualTo: checkbox.leadingAnchor, constant: 106),
            
            checkbox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -23),
            checkbox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkbox.heightAnchor.constraint(equalToConstant: 20),
            checkbox.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    // MARK: - Configure method
    
    func configure(with habit: Habit) {
        habitsName.text = habit.title
        habitsCount.text = "\(habit.progress.values.reduce(0, +)) из \(habit.frequency)"
        let percentage = Int((Double(habit.progress.values.reduce(0, +)) / Double(habit.frequency)) * 100)
        percentDone.text = "\(percentage)%"
    }
}

// MARK: - Methods to create label and image view

extension HabitsCell {
    
    private func createLabel(textColor: UIColor, font: UIFont, alpha: CGFloat = 1.0) -> UILabel {
        let label = UILabel()
        label.textColor = textColor
        label.font = font
        label.alpha = alpha
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func createImageView(imageName: String, tintColor: UIColor, alpha: CGFloat = 1.0) -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        view.tintColor = tintColor
        view.alpha = alpha
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

extension HabitsCell: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer == panGesture
    }
}
