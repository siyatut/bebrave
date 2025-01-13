//
//  HabitsCollectionViewCell.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 10/4/2567 BE.
//

import UIKit

// TODO: - Разделить код на разные файлы. Что-то тут точно можно вынести в другие

class HabitCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
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
    private let buttonWidth: CGFloat = 50
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
        view.backgroundColor = AppStyle.Colors.isProgressHabitColor
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
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if let habit = habit {
            let today = Calendar.current.startOfDay(for: Date())
            let status = habit.getStatus(for: today)
            applySkippedHabitPattern(for: status)
        }
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
            leftButtonContainer.widthAnchor.constraint(equalToConstant: buttonWidth * 2)
        ])
        
        NSLayoutConstraint.activate([
            rightButtonContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rightButtonContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rightButtonContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            rightButtonContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            rightButtonContainer.widthAnchor.constraint(equalToConstant: buttonWidth * 2)
        ])
        
        NSLayoutConstraint.activate([
            contentContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        // По-моему, вот эти 4 строчки снизу можно удалить
        
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
        let rightButtons = [deleteButton, skipButton]
        for (index, button) in rightButtons.enumerated() {
            rightButtonContainer.addSubview(button)
            NSLayoutConstraint.activate([
                button.trailingAnchor.constraint(equalTo: rightButtonContainer.trailingAnchor, constant: -CGFloat(index) * buttonWidth),
                button.topAnchor.constraint(equalTo: rightButtonContainer.topAnchor),
                button.bottomAnchor.constraint(equalTo: rightButtonContainer.bottomAnchor),
                button.widthAnchor.constraint(equalToConstant: buttonWidth)
            ])
        }
        
        let leftButtons = [editButton, cancelButton]
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
        contentContainer.addGestureRecognizer(tapGesture)
    }
    
    private func setupPanGesture() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.cancelsTouchesInView = true
        panGesture.delegate = self
        contentView.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Handle pan gesture
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        switch gesture.state {
        case .began:
            originalCenter = contentContainer.center
            
        case .changed:
            contentContainer.transform = CGAffineTransform(translationX: translation.x, y: 0)
            
        case .ended:
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
        UIView.animate(withDuration: 0.3) {
            self.contentContainer.transform = CGAffineTransform(translationX: self.buttonWidth * 2, y: 0)
            self.leftButtonContainer.isHidden = false
            self.rightButtonContainer.isHidden = true
            self.layoutIfNeeded()
        }
    }
    
    private func showLeftSwipeAction() {
        isSwiped = true
        UIView.animate(withDuration: 0.3) {
            self.contentContainer.transform = CGAffineTransform(translationX: -self.buttonWidth * 2, y: 0)
            self.rightButtonContainer.isHidden = false
            self.leftButtonContainer.isHidden = true
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
        guard var habit = habit else {
            print("No habit found. Exiting tap handler.")
            return
        }
        
        if currentProgress < habit.frequency {
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
        delegate?.habitCell(self, didTriggerAction: .edit, for: habit)
        resetPosition()
    }

    @objc private func skipHabit() {
        guard let habit = habit else { return }
        delegate?.habitCell(self, didTriggerAction: .skipToday, for: habit)
        resetPosition()
    }

    @objc private func cancelHabit() {
        guard let habit = habit else { return }
        if habit.skipDates.contains(Calendar.current.startOfDay(for: Date())) {
            delegate?.habitCell(self, didTriggerAction: .undoSkip, for: habit)
        } else {
            delegate?.habitCell(self, didTriggerAction: .unmarkCompletion, for: habit)
        }
        resetPosition()
    }

       @objc private func confirmDelete() {
           guard let habit = habit else { return }
           let alert = UIAlertController(title: "Точно удаляем привычку?", message: "", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Отмена", style: .cancel) { _ in
               self.resetPosition()
           })
           alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
               guard let self = self else { return }
               self.delegate?.habitCell(self, didTriggerAction: .delete, for: habit)
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
        
        clearLayerPatterns()
        clearCheckmark()
        
        let progressColor: UIColor
        
        switch status {
        case .notCompleted:
            progressColor = Calendar.current.isDateInToday(today) ?
            AppStyle.Colors.backgroundColor : AppStyle.Colors.isUncompletedHabitColor
            currentProgress = 0
        case .partiallyCompleted(let progress, _):
            currentProgress = progress
            progressColor = AppStyle.Colors.backgroundColor
            updateHabitProgress()
        case .completed:
            currentProgress = habit.frequency
            progressColor = AppStyle.Colors.isProgressHabitColor
            drawCheckmark()
        case .skipped:
            currentProgress = 0
            progressColor = AppStyle.Colors.isProgressHabitColor
            applySkippedHabitPattern(for: status)
        }
        
        contentContainer.backgroundColor = progressColor
        contentView.backgroundColor = AppStyle.Colors.isProgressHabitColor
        contentView.layer.cornerRadius = AppStyle.Sizes.cornerRadius
        contentView.layer.masksToBounds = true
        
        habitsName.text = habit.title
    }
    
    private func applySkippedHabitPattern(for status: HabitStatus) {
        
        guard case .skipped = status else { return }
        
        clearLayerPatterns()
        
        let patternLayer = CAShapeLayer()
        patternLayer.frame = contentContainer.bounds
        patternLayer.fillColor = AppStyle.Colors.isProgressHabitColor.cgColor
        patternLayer.strokeColor = AppStyle.Colors.borderColor.cgColor
        patternLayer.lineWidth = 2
        
        let path = UIBezierPath()
        let step: CGFloat = 10
        let diagonalLength = hypot(contentContainer.bounds.width, contentContainer.bounds.height)
        
        for x in stride(from: -diagonalLength, to: diagonalLength, by: step) {
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x + diagonalLength, y: contentContainer.bounds.height))
        }
        
        patternLayer.path = path.cgPath
        patternLayer.lineDashPattern = [4, 4]
        contentContainer.layer.insertSublayer(patternLayer, at: 0)
    }
    
    private func clearLayerPatterns() {
        contentContainer.layer.sublayers?.removeAll { $0 is CAShapeLayer }
    }
}
