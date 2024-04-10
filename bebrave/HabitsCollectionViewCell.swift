//
//  HabitsCollectionViewCell.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 10/4/2567 BE.
//

import UIKit

class HabitsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let habitsName: UILabel = {
        let label = UILabel()
        label.text = "Учить английский"
        return label
    }()
    
    private let percentDone: UILabel = {
        let label = UILabel()
        label.text = "12 %"
        return label
    }()
    
    private let starDivider: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "StarDivider")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
