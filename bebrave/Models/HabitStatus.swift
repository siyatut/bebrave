//
//  File.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 14/1/2568 BE.
//

enum HabitStatus {
    case notCompleted
    case partiallyCompleted(progress: Int, total: Int)
    case completed
    case skipped
}
