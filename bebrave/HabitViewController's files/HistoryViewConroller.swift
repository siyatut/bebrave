//
//  HistoryViewConroller.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 28/2/2567 BE.
//

import UIKit

class HistoryViewController: UIViewController {
    
// MARK: - Lifecycle view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppStyle.Colors.backgroundColor
        title = "История"
        navigationController?.navigationBar.tintColor = AppStyle.Colors.secondaryColor
    }
    
// MARK: - Action
    
    @objc private func dismiss() {
        self.navigationController?.popViewController(animated: true)
    }
}
