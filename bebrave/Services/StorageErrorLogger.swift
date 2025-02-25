//
//  StorageErrorLogger.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 25/2/2568 BE.
//

import Foundation

// MARK: - Storage Error Logger

final class StorageErrorLogger {

    static func handleLoadError(_ error: Error, forKey key: String) {
        #if DEBUG
        assertionFailure("Ошибка при загрузке данных (\(key)): \(error)")
        #else
        logError("Ошибка при загрузке данных (\(key))", error: error)
        #endif
    }

    static func handleSaveError(_ error: Error, forKey key: String) {
        #if DEBUG
        assertionFailure("Ошибка при сохранении данных (\(key)): \(error)")
        #else
        logError("Ошибка при сохранении данных (\(key))", error: error)
        #endif
    }

    private func logError(_ message: String, error: Error) {
        print("\(message): \(error)")

    }

}
