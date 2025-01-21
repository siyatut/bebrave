//
//  HabitCell+LayerEffects.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 13/1/2568 BE.
//

import UIKit

extension HabitCell {
    
    // MARK: - Checkmark methods
    
    func setupCheckmarkLayer() {
        checkmarkLayer.strokeColor = UIColor.black.cgColor
        checkmarkLayer.fillColor = UIColor.clear.cgColor
        checkmarkLayer.lineWidth = 2
        checkmarkLayer.lineCap = .round
        checkmarkLayer.lineJoin = .round
        checkmarkLayer.isHidden = true
        checkbox.layer.addSublayer(checkmarkLayer)
    }
    
    func drawCheckmark() {
        let size = checkbox.bounds.size
        let path = UIBezierPath()
        
        // Начальная точка (левый конец)
        path.move(to: CGPoint(x: size.width * 0.25, y: size.height * 0.4))
        
        // Средняя точка (угол галочки)
        path.addLine(to: CGPoint(x: size.width * 0.5, y: size.height * 0.65))
        
        // Конечная точка (правая часть)
        path.addLine(to: CGPoint(x: size.width * 0.95, y: size.height * 0.0))
        
        checkmarkLayer.path = path.cgPath
        checkmarkLayer.lineCap = .round
        checkmarkLayer.lineJoin = .round
        checkmarkLayer.isHidden = false
    }
    
    func clearCheckmark() {
        checkmarkLayer.isHidden = true
    }
    
    // MARK: - Skipped habit pattern
    
    func createDiagonalPattern(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        let step: CGFloat = 10
        let diagonalLength = hypot(rect.width, rect.height)

        for x in stride(from: -diagonalLength, to: diagonalLength, by: step) {
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x + diagonalLength, y: rect.height))
        }
        return path
    }
    
    func applySkippedHabitPattern(for status: HabitStatus) {
        
        guard case .skipped = status else { return }
        
        clearLayerPatterns()
        
        let patternLayer = CAShapeLayer()
        patternLayer.frame = contentContainer.bounds
        patternLayer.strokeColor = AppStyle.Colors.isProgressHabitColor.cgColor
        patternLayer.lineWidth = 2
        patternLayer.path = createDiagonalPattern(in: contentContainer.bounds).cgPath
        patternLayer.lineDashPattern = [4, 4]
        contentContainer.layer.insertSublayer(patternLayer, at: 0)
    }
    
    func clearLayerPatterns() {
        contentContainer.layer.sublayers?.removeAll { $0 is CAShapeLayer }
    }
}
