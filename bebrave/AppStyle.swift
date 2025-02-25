//
//  AppStyle.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 21/11/2567 BE.
//

import UIKit

struct AppStyle {

    struct Colors {
        static let primaryColor = UIColor(named: "PrimaryAccent") ?? .systemPurple
        static let primaryGreenColor = UIColor(named: "PrimaryGreen") ?? .systemGreen
        static let secondaryColor = UIColor(named: "SecondaryAccent") ?? .tintColor

        static let errorColor = UIColor.red
        static let borderColor = UIColor.systemGray5

        static let textColor = UIColor.label
        static let textColorSecondary = UIColor.secondaryLabel

        static let backgroundColor = UIColor.systemBackground
        static let backgroundEmptyStateColor = UIColor(named: "NeutralGray") ?? .lightGray

        static let isProgressHabitColor = UIColor(named: "SuccessGreen") ?? .systemGreen
        static let isUncompletedHabitColor = UIColor(named: "InactiveGray") ?? .lightGray
        static let isSkippedHabitColor = UIColor(named: "SoftYellow") ?? .systemYellow
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
