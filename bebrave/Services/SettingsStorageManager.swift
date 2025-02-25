//
//  SettingsStorageManager.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 25/2/2568 BE.
//

import Foundation

final class SettingsStorageManager {

    private let defaults = UserDefaults.standard

    // MARK: - Public Methods

    func loadSelectedPeriod() -> Period? {
        guard let data = defaults.data(forKey: UserDefaultsKeys.selectedPeriod) else { return nil }
        do {
            return try JSONDecoder().decode(Period.self, from: data)
        } catch {
            StorageErrorLogger.handleLoadError(error, forKey: UserDefaultsKeys.selectedPeriod)
            return nil
        }
    }

    func saveSelectedPeriod(_ period: Period) {
        do {
            let encodedData = try JSONEncoder().encode(period)
            defaults.set(encodedData, forKey: UserDefaultsKeys.selectedPeriod)
        } catch {
            StorageErrorLogger.handleSaveError(error, forKey: UserDefaultsKeys.selectedPeriod)
        }
    }
}
