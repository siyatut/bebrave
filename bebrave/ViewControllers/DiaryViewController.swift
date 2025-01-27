//
//  DiaryViewController.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 14/2/2567 BE.
//

import UIKit
// swiftlint:disable:next line_length
//  TODO: - Экран в Navigation Controller. В верхней части слева — Дата, справа — История. Новый экран «История» через UIListContentConfiguration. Каждая строчка (конкретный день) тоже должны открываться в новый экран для полного просмотра и возможного редактирования. Основной экран «Дневника» тем временем лист для записи. Потом как-будь можно будет придумать вопросы для помощи в заполнении записей.

class DiaryViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppStyle.Colors.backgroundColor
    }
}
