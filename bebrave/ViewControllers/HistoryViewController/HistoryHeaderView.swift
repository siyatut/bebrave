//
//  HistoryHeaderView.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 16/1/2568 BE.
//

import UIKit
import Combine

class HistoryHeaderView: UICollectionReusableView {

    // MARK: - UI components

    private let periodButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = AppStyle.Colors.secondaryColor
        config.image = UIImage(systemName: "chevron.down.circle.fill")
        config.imagePlacement = .leading
        config.imagePadding = 4
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(
            pointSize: 14,
            weight: .medium
        )

        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var attributes = incoming
            attributes.font = AppStyle.Fonts.regularFont(size: 16)
            return attributes
        }

        let button = UIButton(configuration: config, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let dateLabel = UILabel.styled(text: "", fontSize: 18, isBold: true, alignment: .center)

    // MARK: - Properties

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - UI Setup

    private func setupView() {
        addSubview(periodButton)
        addSubview(dateLabel)

        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            dateLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: periodButton.leadingAnchor,
                constant: -10),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),

            periodButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            periodButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            periodButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }

    // MARK: - Configuration

    func configure(with viewModel: HistoryViewModel, onPeriodChange: @escaping (Period) -> Void) {
        bindViewModel(viewModel)

        periodButton.menu = createPeriodMenu(viewModel: viewModel, onPeriodChange: onPeriodChange)
        periodButton.showsMenuAsPrimaryAction = true

        updateUIForSelectedPeriod(viewModel: viewModel)
    }

    // MARK: - ViewModel Binding

    private func bindViewModel(_ viewModel: HistoryViewModel) {
        viewModel.$dateRangeText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] dateRange in
                self?.dateLabel.text = dateRange
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Period Selection Menu

    private func createPeriodMenu(viewModel: HistoryViewModel, onPeriodChange: @escaping (Period) -> Void) -> UIMenu {
        return UIMenu(title: "Выберите период:", children: [
            UIAction(title: "Неделя", state: viewModel.selectedPeriod == .week ? .on : .off) { _ in
                onPeriodChange(.week)
            },
            UIAction(title: "Месяц", state: viewModel.selectedPeriod == .month ? .on : .off) { _ in
                onPeriodChange(.month)
            },
            UIAction(title: "Полгода", state: viewModel.selectedPeriod == .halfYear ? .on : .off) { _ in
                onPeriodChange(.halfYear)
            },
            UIAction(title: "Год", state: viewModel.selectedPeriod == .year ? .on : .off) { _ in
                onPeriodChange(.year)
            }
        ])
    }

    // MARK: - UI Update

    private func updateUIForSelectedPeriod(viewModel: HistoryViewModel) {
        let periodTitle: String
        switch viewModel.selectedPeriod {
        case .week: periodTitle = "Неделя"
        case .month: periodTitle = "Месяц"
        case .halfYear: periodTitle = "Полгода"
        case .year: periodTitle = "Год"
        }
        periodButton.setTitle(periodTitle, for: .normal)
    }
}
