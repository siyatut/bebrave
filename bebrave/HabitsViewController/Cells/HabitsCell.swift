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
    private lazy var deleteIcon = createImageView(imageName: "Trash", tintColor: .red, alpha: 0)
    
    // MARK: - UI Components
    
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
        setupDeleteIcon()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        deleteIcon.alpha = 0
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
            guard translation.x < 0 else { return } // Лишь влево
            center.x = originalCenter.x + translation.x
            deleteIcon.alpha = min(1, abs(translation.x) / 100)
        case .ended:
            if abs(translation.x) > 100 && translation.x < 0 {
                NotificationCenter.default.post(name: Notification.Name("CellDidSwipeRight"), object: self)
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
            self.deleteIcon.alpha = 0
        }
    }
    
    @objc private func handleTap() {
        print("Cell tapped!")
    }
    
    // MARK: - Set up components
    
    private func setupDeleteIcon() {
        addSubview(deleteIcon)
        NSLayoutConstraint.activate([
            deleteIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            deleteIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -23),
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
            checkbox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
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
    
    private func createLabel(textColor: UIColor, font: UIFont) -> UILabel {
        let label = UILabel()
        label.textColor = textColor
        label.font = font
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
