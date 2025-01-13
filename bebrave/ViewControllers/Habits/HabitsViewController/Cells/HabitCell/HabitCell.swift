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
    var habit: Habit?
    var currentProgress: Int = 0 {
        didSet {
            updateHabitProgress()
        }
    }

    var panGesture: UIPanGestureRecognizer!
    var tapGesture: UITapGestureRecognizer!
    var originalCenter: CGPoint = .zero
    let buttonWidth: CGFloat = 50
    var isSwiped = false
    
    // MARK: - Containers for UI components
    
    lazy var contentContainer: UIView = {
        let view = UIView()
        view.backgroundColor = AppStyle.Colors.backgroundColor
        view.layer.cornerRadius = AppStyle.Sizes.cornerRadius
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var leftButtonContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var rightButtonContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: -  Swipe buttons
    
    lazy var editButton: UIButton = createSwipeButton(imageName: "pencil", color: .systemBlue, action: #selector(editHabit))
    lazy var skipButton: UIButton = createSwipeButton(imageName: "forward", color: .systemOrange, action: #selector(skipHabit))
    lazy var cancelButton: UIButton = createSwipeButton(imageName: "xmark.circle", color: .systemGray, action: #selector(cancelHabit))
    lazy var deleteButton: UIButton = createSwipeButton(imageName: "trash", color: .systemRed, action: #selector(confirmDelete))
    
    
    // MARK: - UI components for cell
    
    lazy var habitsName = createLabel(textColor: .label, font: AppStyle.Fonts.regularFont(size: 16))
    lazy var percentDone = createLabel(textColor: .secondaryLabel, font: AppStyle.Fonts.regularFont(size: 16))
    lazy var habitsCount = createLabel(textColor: .secondaryLabel, font: AppStyle.Fonts.regularFont(size: 16))
    lazy var starDivider = createImageView(imageName: "StarDivider", tintColor: AppStyle.Colors.secondaryColor)
    lazy var checkbox = createImageView(imageName: "UncheckedCheckbox", tintColor: AppStyle.Colors.borderColor)
    let checkmarkLayer = CAShapeLayer()
    var progressViewWidthConstraint: NSLayoutConstraint!
    
    let horizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let progressView: UIView = {
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
    
    func updateHabitProgress() {
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
}
