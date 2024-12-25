//
//  HabitsLayout.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 23/12/2567 BE.
//

import UIKit

class HabitsFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    private func setupLayout() {
        scrollDirection = .vertical
        minimumInteritemSpacing = 8
        minimumLineSpacing = 8
        sectionInset = UIEdgeInsets(top: 24, left: 12, bottom: 24, right: 12)
        itemSize = CGSize(width: UIScreen.main.bounds.width - 24, height: 60)
    }
}
