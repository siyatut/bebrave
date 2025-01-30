//
//  AppStyle.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 21/11/2567 BE.
//

import UIKit

struct AppStyle {

    struct Colors {
        static let primaryColor = UIColor(named: "MyPrimaryColor") ?? .systemPurple
        static let primaryGreenColor = UIColor(named: "MyPrimaryGreenColor") ?? .systemGreen
        static let secondaryColor = UIColor(named: "MySecondaryColor") ?? .tintColor

        static let errorColor = UIColor.red
        static let borderColor = UIColor.systemGray5

        static let textColor = UIColor.label
        static let textColorSecondary = UIColor.secondaryLabel

        static let backgroundColor = UIColor.systemBackground
        static let backgroundEmptyStateColor = UIColor(named: "MyGrayColor") ?? .lightGray

        static let isProgressHabitColor = UIColor(named: "MyGreenColor") ?? .systemGreen
        static let isUncompletedHabitColor = UIColor(named: "MyLightGrayColor") ?? .lightGray
    }

    struct Sizes {
        static let cornerRadius: CGFloat = 18
        static let borderWidth: CGFloat = 1
        static let padding: CGFloat = 12
    }

    struct Fonts {
        static func boldFont(size: CGFloat) -> UIFont {
            return UIFont.boldSystemFont(ofSize: size)
        }

        static func regularFont(size: CGFloat) -> UIFont {
            return UIFont.systemFont(ofSize: size)
        }
    }
}
