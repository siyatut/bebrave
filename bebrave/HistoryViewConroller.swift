//
//  HistoryViewConroller.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 28/2/2567 BE.
//

import UIKit

class HistoryViewController: UIViewController {
    
    // MARK: - UI components
    
    let dismissButton = UIButton()
    
    // MARK: - Lifecycle view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "История"
    }
    
    // MARK: - Objc methods
    
    @objc private func dismissSelf() {
        self.navigationController?.popViewController(animated: true)
    }
}
