//
//  HabitCellProtocols.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 13/1/2568 BE.
//

import UIKit

enum HabitCellAction {
    case edit
    case delete
    case skipToday
    case unmarkCompletion
    case undoSkip
}

protocol HabitCellDelegate: AnyObject {
    func habitCell(_ cell: HabitCell, didTriggerAction action: HabitCellAction, for habit: Habit)
    func habitCellDidStartSwipe(_ cell: HabitCell)
}
