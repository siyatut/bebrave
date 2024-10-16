//
//  AddNewHabitView.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 28/5/2567 BE.
//

import UIKit

class AddNewHabitView: UICollectionReusableView {
    
    // MARK: - UI Components
    
    private let view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let addNewHabitLabel: UILabel = {
        let label = UILabel()
        label.text = "Добавить привычку"
        label.textColor = .tintColor
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let plus: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Plus")
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
    
    func setupComponents() {
        addSubview(view)
        view.addSubview(addNewHabitLabel)
        view.addSubview(plus)
    
        addNewHabitLabel.setContentHuggingPriority(.defaultHigh + 1, for: .horizontal)
       
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
            view.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            addNewHabitLabel.topAnchor.constraint(equalTo: view.topAnchor),
            addNewHabitLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            addNewHabitLabel.leadingAnchor.constraint(equalTo: plus.trailingAnchor, constant: 4),
            addNewHabitLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            plus.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            plus.topAnchor.constraint(equalTo: addNewHabitLabel.topAnchor),
            plus.bottomAnchor.constraint(equalTo: addNewHabitLabel.bottomAnchor),
        ])
    }
}

import SwiftUI

struct NewHabitPreview: PreviewProvider {
    
    static var previews: some View {
        MyCell()
            .edgesIgnoringSafeArea(.all)
            .previewLayout(.fixed(width: 300, height: 60))
    }
    
    struct MyCell: UIViewRepresentable {
        
        func makeUIView(context: Context) -> some UIView {
            AddNewHabitView()
        }

        func updateUIView(_ uiView: UIViewType, context: Context) {
            
        }
    }
}
