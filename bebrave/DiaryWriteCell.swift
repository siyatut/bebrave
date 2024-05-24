//
//  DiaryWriteCell.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 21/5/2567 BE.
//

import UIKit

class DiaryWriteCell: UICollectionViewCell {
    
    // MARK
    
    private let writeDiaryLabel: UILabel = {
        let label = UILabel()
        label.text = "Заполнить дневник"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chevron: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Chevron")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func setupComponents() {
        contentView.addSubview(writeDiaryLabel)
        contentView.addSubview(chevron)
        chevron.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        NSLayoutConstraint.activate([
            writeDiaryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            writeDiaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            chevron.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevron.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -21),
            writeDiaryLabel.trailingAnchor.constraint(equalTo: chevron.leadingAnchor, constant: -21),
            writeDiaryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24.5)
        ])
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


import SwiftUI

struct DiaryWriteCellPreview: PreviewProvider {
    
    static var previews: some View {
        MyCell()
            .edgesIgnoringSafeArea(.all)
            .previewLayout(.fixed(width: 300, height: 60))
    }
    
    struct MyCell: UIViewRepresentable {
        
        func makeUIView(context: Context) -> some UIView {
            DiaryWriteCell()
        }

        func updateUIView(_ uiView: UIViewType, context: Context) {
            
        }
    }
}

