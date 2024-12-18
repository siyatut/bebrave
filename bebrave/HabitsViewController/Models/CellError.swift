//
//  CellError.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 18/12/2567 BE.
//

import Foundation

enum CellError: Error {
    case dequeuingFailed(reuseIdentifier: String)
    case unhandledSectionOrIndexPath(IndexPath)
}
