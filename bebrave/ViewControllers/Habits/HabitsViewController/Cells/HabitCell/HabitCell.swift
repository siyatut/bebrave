//
//  HabitsCollectionViewCell.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 10/4/2567 BE.
//

import UIKit

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
    
    lazy var leftButtonContainer: UIView = createContainer()
    lazy var rightButtonContainer: UIView = createContainer()
    lazy var contentContainer: UIView = createContainer(backgroundColor: AppStyle.Colors.backgroundColor)
    lazy var progressViewContainer: UIView = createContainer(backgroundColor: AppStyle.Colors.isProgressHabitColor, cornerRadius: 0)
    
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
    
    // MARK: - Lifecycle 
    
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
}
