//
//  HabitsCollectionViewCell.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 10/4/2567 BE.
//

import UIKit

// TODO: - Разделить код на разные файлы. Что-то тут точно можно вынести в другие

protocol HabitCellDelegate: AnyObject {
    func markHabitAsNotCompleted(habit: Habit)
    func skipToday(habit: Habit)
}

class HabitsCell: UICollectionViewCell, UIContextMenuInteractionDelegate {
    
    // MARK: - Properties
    
    weak var delegate: HabitCellDelegate?
    private var habit: Habit?
    private var currentProgress: Int = 0 {
        didSet {
            updateHabitProgress()
        }
    }
    
    private let checkmarkLayer = CAShapeLayer()
    private var panGesture: UIPanGestureRecognizer!
    private var originalCenter: CGPoint = .zero
    private var progressViewWidthConstraint: NSLayoutConstraint!
    
    // MARK: -  UI components for swipe
    
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
    
    private let progressView: UIView = {
        let view = UIView()
        view.backgroundColor = AppStyle.Colors.progressViewColor
        view.layer.cornerRadius = AppStyle.Sizes.cornerRadius
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponents()
        setupTapGesture()
        setupPanGesture()
        setupIcons()
        setupCheckmarkLayer()
        
        let interaction = UIContextMenuInteraction(delegate: self)
        self.addInteraction(interaction)
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
        
            deleteHabitIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 45),
            changeHabitIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -45),
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
        contentView.addSubview(progressView)
        progressViewWidthConstraint = progressView.widthAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            progressView.topAnchor.constraint(equalTo: contentView.topAnchor),
            progressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            progressViewWidthConstraint
        ])
        
        contentView.addSubview(horizontalStackView)
        contentView.addSubview(percentDone)
        contentView.addSubview(checkbox)
        
        addSubviewsToStackView(horizontalStackView, views: [habitsName, starDivider, habitsCount])
        
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
    
    // MARK: - Checkmark methods
    
    private func setupCheckmarkLayer() {
        checkmarkLayer.strokeColor = UIColor.black.cgColor
        checkmarkLayer.fillColor = UIColor.clear.cgColor
        checkmarkLayer.lineWidth = 2
        checkmarkLayer.lineCap = .round
        checkmarkLayer.lineJoin = .round
        checkmarkLayer.isHidden = true
        checkbox.layer.addSublayer(checkmarkLayer)
    }
    
    private func drawCheckmark() {
        let size = checkbox.bounds.size
        let path = UIBezierPath()
        
        // Начальная точка (левый конец)
        path.move(to: CGPoint(x: size.width * 0.25, y: size.height * 0.4))
        
        // Средняя точка (угол галочки)
        path.addLine(to: CGPoint(x: size.width * 0.5, y: size.height * 0.65))
        
        // Конечная точка (правая часть)
        path.addLine(to: CGPoint(x: size.width * 0.95, y: size.height * 0.0))
        
        checkmarkLayer.path = path.cgPath
        checkmarkLayer.lineCap = .round
        checkmarkLayer.lineJoin = .round
        checkmarkLayer.isHidden = false
    }
    
    private func clearCheckmark() {
        checkmarkLayer.isHidden = true
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
    
    // MARK: - Handle pan gesture
    
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
    
    // MARK: - Handle tap gesture
    
    @objc private func handleTap() {
        print("Cell tapped!")
        guard var habit = habit, currentProgress < habit.frequency else { return }
        
        currentProgress += 1
        habit.progress[Date()] = currentProgress
        UserDefaultsManager.shared.updateHabit(habit)
        updateHabitProgress()
    }
    
    private func updateHabitProgress() {
        guard let habit = habit else { return }
        
        let totalWidth = contentView.bounds.width
        let percentage = CGFloat(currentProgress) / CGFloat(habit.frequency)
        let newWidth = totalWidth * percentage
        
        habitsCount.text = "\(currentProgress) из \(habit.frequency)"
        percentDone.text = "\(Int(percentage * 100))%"
        
        progressViewWidthConstraint.constant = newWidth
        UIView.animate(withDuration: 0.3) {
            self.contentView.layoutIfNeeded() 
        }
        
        if percentage >= 1.0 {
            drawCheckmark()
        } else {
            clearCheckmark()
        }
    }
    
    // MARK: - Handle long press
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let cancelAction = UIAction(title: "Отменить выполнение", image: UIImage(systemName: "xmark.circle")) { _ in
                guard let habit = self.habit else { return }
                self.delegate?.markHabitAsNotCompleted(habit: habit)
            }
            
            let skipAction = UIAction(title: "Пропустить сегодня", image: UIImage(systemName: "forward")) { _ in
                guard let habit = self.habit else { return }
                self.delegate?.skipToday(habit: habit)
            }
            
            return UIMenu(title: "Опции", children: [cancelAction, skipAction])
        }
    }
    
    // MARK: - Configure method
    
    func configure(with habit: Habit) {
        
        if let savedHabit = UserDefaultsManager.shared.loadHabits().first(where: { $0.id == habit.id }) {
            self.habit = savedHabit
        } else {
            self.habit = habit
        }
        
        self.currentProgress = self.habit?.progress.values.reduce(0, +) ?? 0
        habitsName.text = habit.title
        updateHabitProgress()
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
