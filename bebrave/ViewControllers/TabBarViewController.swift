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
        tabBar.backgroundColor = AppStyle.Colors.backgroundColor
        tabBar.tintColor = AppStyle.Colors.primaryColor
    }

    // MARK: - Setup Tab Bar

    private func setupTabs() {
        let tabs: [TabItem] = [.habits, .diary, .profile]
        let viewControllers = tabs.map { createNavigationController(for: $0) }
        setViewControllers(viewControllers, animated: true)
    }

    private func createNavigationController(for tabItem: TabItem) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: tabItem.viewController)
        navigationController.tabBarItem = UITabBarItem(
            title: tabItem.title,
            image: tabItem.icon,
            tag: tabItem.rawValue
        )
        return navigationController
    }
}
