//
//  OutlineBackgroundView.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 21/3/2567 BE.
//

import UIKit

class OutlineBackgroundView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay() 
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 18)
        path.lineWidth = 1
        UIColor.systemGray5.setStroke()
        path.stroke()
    }
}

