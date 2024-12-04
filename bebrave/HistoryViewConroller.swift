//
//  HistoryViewConroller.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 28/2/2567 BE.
//

import UIKit

class HistoryViewController: UIViewController {
    
// MARK: - UI components
#warning("Когда буду писать этот экран, надо учесть цвет кнопки. Наверное, можно просто AccentColor поменять в Asset")
    
    let dismissButton = UIButton()
    
// MARK: - Lifecycle view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppStyle.Colors.backgroundColor
        title = "История"
    }
    
// MARK: - Action
    
    @objc private func dismiss() {
        self.navigationController?.popViewController(animated: true)
    }
}
