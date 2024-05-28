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
        addSubview(addNewHabitLabel)
        addSubview(plus)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            
            plus.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 90.5),
            plus.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            plus.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
//            plus.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12),
            plus.trailingAnchor.constraint(equalTo: addNewHabitLabel.leadingAnchor, constant: -4),
            
            addNewHabitLabel.leadingAnchor.constraint(equalTo: plus.trailingAnchor, constant: 4),
            addNewHabitLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 14.5),
            addNewHabitLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -90.5),
            addNewHabitLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -14.5)
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
