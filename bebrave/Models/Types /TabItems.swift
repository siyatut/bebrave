//
//  TabBarViewController.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 25/2/2568 BE.
//

import UIKit

// MARK: - Tab Bar Items

enum TabItem: Int, CaseIterable {

    case habits
    case diary
    case profile

    var title: String {
        switch self {
        case .habits: return "Привычки"
        case .diary: return "Дневник"
        case .profile: return "Профиль"
        }
    }

    var icon: UIImage? {
        return .temporaryTabbarIcon
    }

    var viewController: UIViewController {
        switch self {
        case .habits: return HabitsViewController()
        case .diary: return DiaryViewController()
        case .profile: return ProfileViewController()
        }
    }
}
