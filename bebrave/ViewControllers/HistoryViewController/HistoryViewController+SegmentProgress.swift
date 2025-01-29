//
//  HistoryViewController+SegmentProgress.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 29/1/2568 BE.
//

import UIKit

class SegmentedProgressBar: UIView {
    
    // MARK: - Properties
    
    private var segments: [(color: UIColor, ratio: CGFloat)] = []
    
    // MARK: - Setup
    
    func setSegments(_ segments: [(color: UIColor, ratio: CGFloat)]) {
        self.segments = segments
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard !segments.isEmpty else { return }
        
        let totalWidth = bounds.width
        var currentX: CGFloat = 0
        
        for segment in segments {
            let segmentWidth = totalWidth * segment.ratio
            let segmentRect = CGRect(x: currentX, y: 0, width: segmentWidth, height: bounds.height)
            
            let segmentPath = UIBezierPath(rect: segmentRect)
            segment.color.setFill()
            segmentPath.fill()
            
            currentX += segmentWidth
        }
    }
}
