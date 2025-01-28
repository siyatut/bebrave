//
//  HabitCell+Layout.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 13/1/2568 BE.
//

import UIKit

extension HabitCell {
    
    func addSubviewsToStackView(_ stackView: UIStackView, views: [UIView]) {
        views.forEach { stackView.addArrangedSubview($0) }
    }
    
    func setupComponents() {
        setupSubviews()
        setupContentView()
        setupLeftAndRightButtonContainers()
        setupContentContainer()
        setupProgressViewContainer()
        setupCheckbox()
        setupHorizontalStackView()
        setupButtonConstraints()
    }
    
    private func setupSubviews() {
        contentView.addSubview(rightButtonContainer)
        contentView.addSubview(leftButtonContainer)
        contentView.addSubview(contentContainer)
    }
    
    private func setupContentView() {
        contentView.layer.cornerRadius = AppStyle.Sizes.cornerRadius
        contentView.layer.masksToBounds = true
        contentContainer.layer.masksToBounds = true
    }
    
    private func setupLeftAndRightButtonContainers() {
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
    }
    
    private func setupContentContainer() {
        NSLayoutConstraint.activate([
            contentContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    // swiftlint:disable line_length
    private func setupProgressViewContainer() {
        contentContainer.addSubview(progressViewContainer)
        progressViewWidthConstraint = progressViewContainer.widthAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            progressViewContainer.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            progressViewContainer.topAnchor.constraint(equalTo: contentContainer.topAnchor),
            progressViewContainer.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor),
            progressViewWidthConstraint
        ])
    }
    
    private func setupCheckbox() {
        contentContainer.addSubview(checkbox)
        
        NSLayoutConstraint.activate([
            checkbox.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -23),
            checkbox.centerYAnchor.constraint(equalTo: contentContainer.centerYAnchor),
            checkbox.heightAnchor.constraint(equalToConstant: 20),
            checkbox.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupHorizontalStackView() {
        contentContainer.addSubview(horizontalStackView)
        contentContainer.addSubview(percentDone)
        
        habitsName.lineBreakMode = .byTruncatingTail
        habitsName.numberOfLines = 1
        
        addSubviewsToStackView(horizontalStackView, views: [habitsName, starDivider, habitsCount])
        
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(
                equalTo: contentContainer.leadingAnchor,
                constant: 16
            ),
            horizontalStackView.topAnchor.constraint(
                equalTo: contentContainer.topAnchor,
                constant: 10
            ),
            horizontalStackView.trailingAnchor.constraint(
                lessThanOrEqualTo: checkbox.leadingAnchor,
                constant: -23
            ),
            percentDone.topAnchor.constraint(
                equalTo: horizontalStackView.bottomAnchor,
                constant: 4
            ),
            percentDone.bottomAnchor.constraint(
                equalTo: contentContainer.bottomAnchor,
                constant: -12
            ),
            percentDone.leadingAnchor.constraint(
                equalTo: horizontalStackView.leadingAnchor
            ),
            percentDone.trailingAnchor.constraint(
                lessThanOrEqualTo: checkbox.leadingAnchor,
                constant: 106
            )
        ])
    }
    
    private func setupButtonConstraints() {
        let rightButtons = [deleteButton, skipButton]
        for (index, button) in rightButtons.enumerated() {
            rightButtonContainer.addSubview(button)
            NSLayoutConstraint.activate([
                button.trailingAnchor.constraint(equalTo: rightButtonContainer.trailingAnchor,
                                                 constant: -CGFloat(index) * buttonWidth),
                button.topAnchor.constraint(equalTo: rightButtonContainer.topAnchor),
                button.bottomAnchor.constraint(equalTo: rightButtonContainer.bottomAnchor),
                button.widthAnchor.constraint(equalToConstant: buttonWidth)
            ])
        }
        
        let leftButtons = [editButton, cancelButton]
        for (index, button) in leftButtons.enumerated() {
            leftButtonContainer.addSubview(button)
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: leftButtonContainer.leadingAnchor,
                                                constant: CGFloat(index) * buttonWidth),
                button.topAnchor.constraint(equalTo: leftButtonContainer.topAnchor),
                button.bottomAnchor.constraint(equalTo: leftButtonContainer.bottomAnchor),
                button.widthAnchor.constraint(equalToConstant: buttonWidth)
            ])
        }
    }
}
// swiftlint:enable line_length
