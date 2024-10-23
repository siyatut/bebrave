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
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 18)
        path.lineWidth = 1
        if let borderColor = UIColor(named: "OutlineBorderColor") {
            borderColor.setStroke()
        } else {
            UIColor.darkGray.setStroke()
        }
        path.stroke()
    }
}

import SwiftUI

struct OutlineBackgroundPreview: PreviewProvider {
    
    static var previews: some View {
        OutlineBackground()
            .edgesIgnoringSafeArea(.all)
            .previewLayout(.fixed(width: 300, height: 60))
    }
    
    struct OutlineBackground: UIViewRepresentable {
        
        func makeUIView(context: Context) -> some UIView {
            OutlineBackgroundView()
        }

        func updateUIView(_ uiView: UIViewType, context: Context) {
            
        }
    }
}
