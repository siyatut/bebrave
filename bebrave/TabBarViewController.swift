//
//  ViewController.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 14/2/2567 BE.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    // MARK: - Lifecycle 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBar.backgroundColor = AppStyle.Colors.backgroundColor
        self.tabBar.tintColor = AppStyle.Colors.primaryColor
    }
    
    
    // MARK: — Setup tab bar
    
    private func setupTabs() {
        
        let habits = self.createNavigationController(with: "Привычки", and: .temporaryTabbarIcon, vc: HabitsViewController())
        let diary = self.createNavigationController(with: "Дневник", and: .temporaryTabbarIcon, vc: DiaryViewController())
        let settings = self.createNavigationController(with: "Профиль", and: .temporaryTabbarIcon, vc: ProfileViewController())
        self.setViewControllers([habits, diary, settings], animated: true)
    }
    
    private func createNavigationController(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        return navigationController
    }
}

