//
//  NewHabitView+Formatting.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 31/12/2567 BE.
//

import UIKit

extension NewHabitViewController {
    
    func dayText(for value: Int) -> String {
        switch value {
        case 2...4: return "раза в день"
        default: return "раз в день"
        }
    }
    
    func monthText(for value: Int) -> String {
        guard (1...125).contains(value) else { return "месяцев" }
        
        let lastDigit = value % 10
        let lastTwoDigits = value % 100
        
        switch lastDigit {
        case 1 where lastTwoDigits != 11:
            return "месяц"
        case 2...4 where !(12...14).contains(lastTwoDigits):
            return "месяца"
        default:
            return "месяцев"
        }
    }
}
