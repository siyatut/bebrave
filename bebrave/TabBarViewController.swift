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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if tabBar.subviews.contains(where: { $0.tag == 999 }) { return }
        
        let lineView = UIView()
        lineView.backgroundColor = AppStyle.Colors.borderColor
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.tag = 999
        
        tabBar.addSubview(lineView)
        
        NSLayoutConstraint.activate([
            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            lineView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -7)
        ])
    }
        
    
// MARK: — Setup tab bar
    
    private func setupTabs() {
        
        let habits = self.createNavigationController(with: "Привычки", and: UIImage(named: "Habits"), vc: HabitsViewController())
        let diary = self.createNavigationController(with: "Дневник", and: UIImage(named: "Diary"), vc: DiaryViewController())
        let settings = self.createNavigationController(with: "Профиль", and: UIImage(named: "Profile"), vc: ProfileViewController())
        self.setViewControllers([habits, diary, settings], animated: true)
    }
    
    private func createNavigationController(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        return navigationController
    }
}

