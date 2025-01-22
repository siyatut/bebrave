//
//  HistoryHeaderView.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 16/1/2568 BE.
//

import UIKit

class HistoryHeaderView: UICollectionReusableView {
    
    // MARK: - UI components
    
    private let periodButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = AppStyle.Colors.secondaryColor
        config.image = UIImage(systemName: "chevron.down.circle.fill")
        config.imagePlacement = .leading
        config.imagePadding = 4
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var attributes = incoming
            attributes.font = AppStyle.Fonts.regularFont(size: 16)
            return attributes
        }
        
        let button = UIButton(configuration: config, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = AppStyle.Fonts.boldFont(size: 18)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var onPeriodChange: ((Period) -> Void)?
    private var selectedPeriod: Period = {
        return UserDefaultsManager.shared.loadSelectedPeriod() ?? .week
    }() {
        didSet {
            UserDefaultsManager.shared.saveSelectedPeriod(selectedPeriod)
            updateUIForSelectedPeriod()
        }
    }
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Setup UI
    
    private func setupView() {
        addSubview(periodButton)
        addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: periodButton.leadingAnchor, constant: -10),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            periodButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            periodButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            periodButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        
        updateUIForSelectedPeriod()
    }
    
    // MARK: - Actions
    
    private func setupActions() {
        periodButton.menu = createPeriodMenu()
        periodButton.showsMenuAsPrimaryAction = true
    }
    
    private func createPeriodMenu() -> UIMenu {
        return UIMenu(title: "Выберите период:", children: [
            UIAction(title: "Неделя", state: selectedPeriod == .week ? .on : .off) { _ in
                self.selectedPeriod = .week
                self.onPeriodChange?(.week)
            },
            UIAction(title: "Месяц", state: selectedPeriod == .month ? .on : .off) { _ in
                self.selectedPeriod = .month
                self.onPeriodChange?(.month)
            },
            UIAction(title: "Полгода", state: selectedPeriod == .halfYear ? .on : .off) { _ in
                self.selectedPeriod = .halfYear
                self.onPeriodChange?(.halfYear)
            },
            UIAction(title: "Целый год", state: selectedPeriod == .year ? .on : .off) { _ in
                self.selectedPeriod = .year
                self.onPeriodChange?(.year)
            }
        ])
    }
    
    // MARK: - Update UI
    
    private func updateUIForSelectedPeriod() {
        let periodTitle: String
        switch selectedPeriod {
        case .week: periodTitle = "Неделя"
        case .month: periodTitle = "Месяц"
        case .halfYear: periodTitle = "Полгода"
        case .year: periodTitle = "Целый год"
        }
        periodButton.setTitle(periodTitle, for: .normal)
        dateLabel.text = calculateDateRange(for: selectedPeriod)
        periodButton.menu = createPeriodMenu()
    }
    
    // MARK: - Configure
    
    func configure(onPeriodChange: @escaping (Period) -> Void) {
        self.onPeriodChange = onPeriodChange
    }
    
    private func calculateDateRange(for period: Period) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        let calendar = Calendar.current
        let today = Date()
        
        var startDate: Date?
        var endDate: Date?
        
        switch period {
        case .week:
            startDate = calendar.date(byAdding: .day, value: -6, to: today)
            endDate = today
        case .month:
            startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: today))
            endDate = calendar.date(byAdding: .month, value: 1, to: startDate!)?.addingTimeInterval(-1)
        case .halfYear:
            startDate = calendar.date(byAdding: .month, value: -5, to: today)
            endDate = today
        case .year:
            startDate = calendar.date(byAdding: .year, value: -1, to: today)
            endDate = today
        }
        
        if let start = startDate, let end = endDate {
            return "\(formatter.string(from: start))–\(formatter.string(from: end))"
        }
        return ""
    }
}
