//
//  OutlineBackgroundView.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 21/3/2567 BE.
//

import UIKit

class OutlineBackgroundView: UICollectionReusableView {

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }

    // MARK: - Drawing

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: AppStyle.Sizes.cornerRadius)
        path.lineWidth = 1
        UIColor.systemGray5.setStroke()
        path.stroke()
    }
}
