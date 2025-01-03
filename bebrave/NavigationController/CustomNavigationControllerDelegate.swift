//
//  CustomNavigationControllerDelegate.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 3/1/2568 BE.
//

import UIKit

class CustomNavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    private let customAnimator = CustomPushAnimator()
    
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return operation == .push ? customAnimator : nil
    }
}
