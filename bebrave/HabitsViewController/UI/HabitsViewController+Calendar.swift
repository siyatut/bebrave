//
//  HabitsViewController+UISetup.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 18/12/2567 BE.
//

import UIKit

// MARK: - Calendar label update

extension HabitsViewController {
    func updateCalendarLabel() {
        guard let header = headerView else {
            print("Header is not visible or initialized.")
            return
        }
        
        let dates = header.getDisplayedDates()
        
        guard let firstDate = dates.first, let lastDate = dates.last else {
            assertionFailure("Dates array is empty")
            return
        }
        
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "LLLL"
        
        let firstMonth = formatter.string(from: firstDate).capitalized
        let lastMonth = formatter.string(from: lastDate).lowercased()
        
        if calendar.isDate(firstDate, equalTo: lastDate, toGranularity: .month) {
            calendarLabel.text = firstMonth
        } else {
            calendarLabel.text = "\(firstMonth)–\(lastMonth)"
        }
    }
}
