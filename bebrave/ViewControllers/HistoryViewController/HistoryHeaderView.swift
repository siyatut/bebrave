//
//  HistoryHeaderView.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 16/1/2568 BE.
//

import UIKit

enum Period {
    case week
    case month
    case halfYear
    case year
}

class HistoryHeaderView: UICollectionReusableView {
    
    // MARK: - UI components
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Неделя", "Месяц", "Полгода", "Год"])
        control.selectedSegmentIndex = 1
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "01.01.2025 - 31.01.2025"
        label.font = AppStyle.Fonts.regularFont(size: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var onPeriodChange: ((Period) -> Void)?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupActions()
    }
    
    // MARK: - Setup UI
    
    private func setupView() {
        addSubview(segmentedControl)
        addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: - Actions
    
    private func setupActions() {
        segmentedControl.addTarget(self, action: #selector(periodChanged), for: .valueChanged)
    }
    
    @objc private func periodChanged() {
        let selectedPeriod: Period
        switch segmentedControl.selectedSegmentIndex {
        case 0: selectedPeriod = .week
        case 1: selectedPeriod = .month
        case 2: selectedPeriod = .halfYear
        case 3: selectedPeriod = .year
        default: return
        }
    
        onPeriodChange?(selectedPeriod)
    }
    
    // MARK: - Configure
    
    func configure(onPeriodChange: @escaping (Period) -> Void) {
        self.onPeriodChange = onPeriodChange
    }
    
    private func calculateDateRange(for period: Period) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
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
            return "\(formatter.string(from: start))——\(formatter.string(from: end))"
        }
        return ""
    }
}
