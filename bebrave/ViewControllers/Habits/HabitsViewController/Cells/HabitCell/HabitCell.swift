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
        view.layer.cornerRadius = AppStyle.Sizes.cornerRadius
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var rightButtonContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = AppStyle.Sizes.cornerRadius
        view.layer.masksToBounds = true
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
    let progressView: UIView = {
        let view = UIView()
        view.backgroundColor = AppStyle.Colors.isProgressHabitColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let horizontalStackView: UIStackView = {
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
    
    // MARK: - Update habit progress
    
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
    
    // MARK: - Configure method
    
    func configure(with habit: Habit) {
        self.habit = habit
        resetCellState()
        
        let today = Calendar.current.startOfDay(for: Date())
        let status = habit.getStatus(for: today)
        
        switch status {
        case .notCompleted:
            contentContainer.backgroundColor = Calendar.current.isDateInToday(today) ?
            AppStyle.Colors.backgroundColor : AppStyle.Colors.isUncompletedHabitColor
        case .partiallyCompleted(let progress, _):
            currentProgress = progress
            updateHabitProgress()
        case .completed:
            currentProgress = habit.frequency
            drawCheckmark()
        case .skipped:
            applySkippedHabitPattern(for: status)
        }

        habitsName.text = habit.title
    }
    
    func resetCellState() {
        clearCheckmark()
        clearLayerPatterns()
        currentProgress = 0
        contentContainer.backgroundColor = AppStyle.Colors.backgroundColor
        contentView.backgroundColor = AppStyle.Colors.isProgressHabitColor
        contentView.layer.cornerRadius = AppStyle.Sizes.cornerRadius
        contentView.layer.masksToBounds = true
    }
}
