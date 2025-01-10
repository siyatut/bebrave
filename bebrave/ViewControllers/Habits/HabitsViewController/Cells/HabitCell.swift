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
    func editHabit(habit: Habit)
    func deleteHabit(habit: Habit)
}

class HabitCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    weak var delegate: HabitCellDelegate?
    private var habit: Habit?
    private var currentProgress: Int = 0 {
        didSet {
            updateHabitProgress()
        }
    }

    private var panGesture: UIPanGestureRecognizer!
    private var tapGesture: UITapGestureRecognizer!
    private var originalCenter: CGPoint = .zero
    private let buttonWidth: CGFloat = 80
    private var isSwiped = false
    
    // MARK: - Containers for UI components
    
    private lazy var contentContainer: UIView = {
        let view = UIView()
        view.backgroundColor = AppStyle.Colors.backgroundColor
        view.layer.cornerRadius = AppStyle.Sizes.cornerRadius
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var leftButtonContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var rightButtonContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: -  Swipe buttons
    
    private lazy var editButton: UIButton = createSwipeButton(imageName: "pencil", color: .systemBlue, action: #selector(editHabit))
    private lazy var skipButton: UIButton = createSwipeButton(imageName: "forward", color: .systemOrange, action: #selector(skipHabit))
    private lazy var cancelButton: UIButton = createSwipeButton(imageName: "xmark.circle", color: .systemGray, action: #selector(cancelHabit))
    private lazy var deleteButton: UIButton = createSwipeButton(imageName: "trash", color: .systemRed, action: #selector(confirmDelete))
    
    
    // MARK: - UI components for cell
    
    private lazy var habitsName = createLabel(textColor: .label, font: AppStyle.Fonts.regularFont(size: 16))
    private lazy var percentDone = createLabel(textColor: .secondaryLabel, font: AppStyle.Fonts.regularFont(size: 16))
    private lazy var habitsCount = createLabel(textColor: .secondaryLabel, font: AppStyle.Fonts.regularFont(size: 16))
    private lazy var starDivider = createImageView(imageName: "StarDivider", tintColor: AppStyle.Colors.secondaryColor)
    private lazy var checkbox = createImageView(imageName: "UncheckedCheckbox", tintColor: AppStyle.Colors.borderColor)
    private let checkmarkLayer = CAShapeLayer()
    private var progressViewWidthConstraint: NSLayoutConstraint!
    
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
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponents()
        setupTapGesture()
        setupPanGesture()
        setupCheckmarkLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isSwiped = false
        resetPosition(animated: false)
    }
    
    // MARK: - Set up components
    
    private func addSubviewsToStackView(_ stackView: UIStackView, views: [UIView]) {
        views.forEach { stackView.addArrangedSubview($0) }
    }
    
    private func setupComponents() {
        contentView.addSubview(rightButtonContainer)
        contentView.addSubview(leftButtonContainer)
        contentView.addSubview(contentContainer)
        
        NSLayoutConstraint.activate([
            leftButtonContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            leftButtonContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            leftButtonContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            leftButtonContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            leftButtonContainer.widthAnchor.constraint(equalToConstant: buttonWidth * 3)
        ])
        
        NSLayoutConstraint.activate([
            rightButtonContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rightButtonContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rightButtonContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            rightButtonContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            rightButtonContainer.widthAnchor.constraint(equalToConstant: buttonWidth)
        ])
        
        NSLayoutConstraint.activate([
            contentContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        contentView.clipsToBounds = false
        leftButtonContainer.clipsToBounds = false
        rightButtonContainer.clipsToBounds = false
        contentContainer.clipsToBounds = true

        contentContainer.addSubview(progressView)
        progressViewWidthConstraint = progressView.widthAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            progressView.topAnchor.constraint(equalTo: contentContainer.topAnchor),
            progressView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor),
            progressViewWidthConstraint
        ])
        
        contentContainer.addSubview(horizontalStackView)
        contentContainer.addSubview(percentDone)
        contentContainer.addSubview(checkbox)
        
        addSubviewsToStackView(horizontalStackView, views: [habitsName, starDivider, habitsCount])
        
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 16),
            horizontalStackView.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 10),
            horizontalStackView.trailingAnchor.constraint(lessThanOrEqualTo: checkbox.leadingAnchor, constant: 106),
            
            percentDone.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 4),
            percentDone.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -12),
            percentDone.leadingAnchor.constraint(equalTo: horizontalStackView.leadingAnchor),
            percentDone.trailingAnchor.constraint(lessThanOrEqualTo: checkbox.leadingAnchor, constant: 106),
            
            checkbox.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -23),
            checkbox.centerYAnchor.constraint(equalTo: contentContainer.centerYAnchor),
            checkbox.heightAnchor.constraint(equalToConstant: 20),
            checkbox.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        leftButtonContainer.isHidden = false
        rightButtonContainer.isHidden = false
        
        setupButtonConstraints()
    }
    
    private func setupButtonConstraints() {
        rightButtonContainer.addSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.trailingAnchor.constraint(equalTo: rightButtonContainer.trailingAnchor),
            deleteButton.topAnchor.constraint(equalTo: rightButtonContainer.topAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: rightButtonContainer.bottomAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: buttonWidth)
        ])
        
        let leftButtons = [editButton, skipButton, cancelButton]
        for (index, button) in leftButtons.enumerated() {
            leftButtonContainer.addSubview(button)
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: leftButtonContainer.leadingAnchor, constant: CGFloat(index) * buttonWidth),
                button.topAnchor.constraint(equalTo: leftButtonContainer.topAnchor),
                button.bottomAnchor.constraint(equalTo: leftButtonContainer.bottomAnchor),
                button.widthAnchor.constraint(equalToConstant: buttonWidth)
            ])
        }
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
        tapGesture.delegate = self
        contentView.addGestureRecognizer(tapGesture)
        print("Tap gesture initialized")
    }
    
    private func setupPanGesture() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.cancelsTouchesInView = true
        panGesture.delegate = self
        contentView.addGestureRecognizer(panGesture)
        print("Pan gesture initialized")
    }
    
    // MARK: - Handle pan gesture
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        switch gesture.state {
        case .began:
            print("Pan gesture began.")
            originalCenter = contentContainer.center
            
        case .changed:
            print("Pan gesture changed. Translation X: \(translation.x)")
            contentContainer.transform = CGAffineTransform(translationX: translation.x, y: 0)
            
        case .ended:
            print("Pan gesture ended. Translation X: \(translation.x)")
            if translation.x < -buttonWidth {
                showLeftSwipeAction()
            } else if translation.x > buttonWidth {
                showRightSwipeActions()
            } else {
                resetPosition()
            }
        default:
            break
        }
    }
    
    private func showRightSwipeActions() {
        isSwiped = true
        print("Showing right swipe actions. isSwiped: \(isSwiped)")
        UIView.animate(withDuration: 0.3) {
            self.contentContainer.transform = CGAffineTransform(translationX: self.buttonWidth * 3, y: 0)
            self.leftButtonContainer.isHidden = false
            self.layoutIfNeeded()
        }
    }
    
    private func showLeftSwipeAction() {
        isSwiped = true
        print("Showing left swipe action. isSwiped: \(isSwiped)")
        UIView.animate(withDuration: 0.3) {
            self.contentContainer.transform = CGAffineTransform(translationX: -self.buttonWidth, y: 0)
            self.rightButtonContainer.isHidden = false
            self.layoutIfNeeded()
        }
    }
    
    @objc private func resetPosition(animated: Bool = true) {
        isSwiped = false
        let animations = {
            self.contentContainer.transform = .identity
            self.leftButtonContainer.isHidden = true
            self.rightButtonContainer.isHidden = true
        }
        if animated {
            UIView.animate(withDuration: 0.3, animations: animations)
        } else {
            animations()
        }
    }
    
    // MARK: - Handle tap gesture
    
    @objc private func handleTap() {
        print("Cell tapped! isSwiped: \(isSwiped)")
        
        guard var habit = habit else {
            print("No habit found. Exiting tap handler.")
            return
        }

        let today = Calendar.current.startOfDay(for: Date())
        
        if habit.skipDates.contains(today) {
            print("Habit skipped today. Removing skip date.")
            habit.skipDates.remove(today)
            
            habit.progress[today] = 0
            currentProgress = 0
            UserDefaultsManager.shared.updateHabit(habit)
            configure(with: habit)
            return
        }
        
        if currentProgress < habit.frequency {
            print("Marking habit as completed.")
            habit.markCompleted()
            currentProgress += 1
            UserDefaultsManager.shared.updateHabit(habit)
            configure(with: habit)
        } else {
            print("Habit already completed.")
        }
    }
    
    private func updateHabitProgress() {
        guard let habit = habit else { return }
        
        let totalWidth = contentView.bounds.width
        let percentage = CGFloat(currentProgress) / CGFloat(habit.frequency)
        let newWidth = totalWidth * percentage
        
        habitsCount.text = "\(currentProgress) из \(habit.frequency)"
        percentDone.text = "\(Int(percentage * 100))%"
        
        progressViewWidthConstraint.constant = newWidth
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut]) {
            self.contentView.layoutIfNeeded()
        }
        
        if percentage >= 1.0 {
            drawCheckmark()
        } else {
            clearCheckmark()
        }
    }
    
    // MARK: - Button Actions
    
       @objc private func editHabit() {
           guard let habit = habit else { return }
           delegate?.editHabit(habit: habit)
           resetPosition()
       }

       @objc private func skipHabit() {
           guard let habit = habit else { return }
           delegate?.skipToday(habit: habit)
           resetPosition()
       }

       @objc private func cancelHabit() {
           guard let habit = habit else { return }
           delegate?.markHabitAsNotCompleted(habit: habit)
           resetPosition()
       }

       @objc private func confirmDelete() {
           guard let habit = habit else { return }
           let alert = UIAlertController(title: "", message: "Точно удаляем привычку?", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Отмена", style: .cancel) { _ in
               self.resetPosition()
           })
           alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
               guard let self = self else { return }
               self.delegate?.deleteHabit(habit: habit)
               self.resetPosition()
           })
           
           if let viewController = self.window?.rootViewController {
               viewController.present(alert, animated: true, completion: nil)
           }
       }

    
    // MARK: - Configure method
    
    func configure(with habit: Habit) {
        self.habit = habit
        let today = Calendar.current.startOfDay(for: Date())
        let status = habit.getStatus(for: today)
        let progressColor: UIColor
        
        switch status {
        case .notCompleted:
            progressColor = Calendar.current.isDateInToday(today) ?
            AppStyle.Colors.backgroundColor : AppStyle.Colors.isUncompletedHabit
            currentProgress = 0
            clearCheckmark()
        case .partiallyCompleted(let progress, _):
            currentProgress = progress
            progressColor = AppStyle.Colors.backgroundColor
            updateHabitProgress()
        case .completed:
            currentProgress = habit.frequency
            progressColor = AppStyle.Colors.progressViewColor
            drawCheckmark()
        case .skipped:
            currentProgress = 0
            progressColor = AppStyle.Colors.isSkippedHabit
            clearCheckmark()
        }
        
        contentView.layer.backgroundColor = progressColor.cgColor
        contentView.layer.cornerRadius = AppStyle.Sizes.cornerRadius
        contentView.layer.masksToBounds = true
        
        habitsName.text = habit.title
    }
}

// MARK: - Methods to create label and image view

extension HabitCell {
    
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
    
    private func createSwipeButton(imageName: String, color: UIColor, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: imageName), for: .normal)
        button.tintColor = .white
        button.backgroundColor = color
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
}

extension HabitCell: UIGestureRecognizerDelegate {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panGesture {
            print("Pan gesture should begin.")
            return true
        }
        
        if gestureRecognizer == tapGesture {
            print("Tap gesture attempted. isSwiped: \(isSwiped)")
            // Блокируем само начало tapGesture, если свайп активен
            if isSwiped {
                print("Blocking tap gesture because isSwiped is true.")
                return false
            }
        }
        
        print("Gesture \(gestureRecognizer) allowed to begin.")
        return true
    }
}
