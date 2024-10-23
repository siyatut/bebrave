//
//  HabitsCollectionViewCell.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 10/4/2567 BE.
//

import UIKit

class HabitsCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let habitsName: UILabel = {
        let label = UILabel()
        label.text = "Учить английский"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let percentDone: UILabel = {
        let label = UILabel()
        label.text = "12 %"
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let starDivider: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "StarDivider")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let habitsCount: UILabel = {
        let label = UILabel()
        label.text = "2 из 3"
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let horizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let checkbox: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Checkbox")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = UIColor(named: "OutlineBorderColor")
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
    
    private func setupComponents() {
        let views = [habitsName, starDivider, habitsCount]
        for view in views {
            horizontalStackView.addArrangedSubview(view)
        }
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
}


import SwiftUI

struct HabitsCellPreview: PreviewProvider {
    
    static var previews: some View {
        MyCell()
            .edgesIgnoringSafeArea(.all)
            .previewLayout(.fixed(width: 300, height: 60))
    }
    
    struct MyCell: UIViewRepresentable {
        
        func makeUIView(context: Context) -> some UIView {
            HabitsCell()
        }

        func updateUIView(_ uiView: UIViewType, context: Context) {
            
        }
    }
}

