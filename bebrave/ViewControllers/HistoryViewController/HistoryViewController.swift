//
//  HistoryViewConroller.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 28/2/2567 BE.
//
// swiftlint:disable:next line_length
// TODO: - Настроить отображение прогресса и закрашивания в соответствии со статусом: зелёный, полосатый зелёный, серый. UPD: с зелёным и серым вроде ок, но паттерн для спипа отрисовать не получилось

import UIKit
import Combine

class HistoryViewController: UIViewController {

    // MARK: - UI Components

    private var collectionView: UICollectionView!

    private lazy var emptyStateView: EmptyStateView = {
        let view = EmptyStateView(text: "История пока пуста")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    // MARK: - ViewModel and Data Binding

    let viewModel: HistoryViewModel
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    init(viewModel: HistoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppStyle.Colors.backgroundColor
        navigationController?.navigationBar.tintColor = AppStyle.Colors.secondaryColor
        setupCollectionView()
        setupEmptyStateView()
        bindViewModel()
    }

    // MARK: - ViewModel Binding

    private func bindViewModel() {
        viewModel.$habitsProgress
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
                self?.emptyStateView.isHidden = !(self?.viewModel.habitsProgress.isEmpty ?? true)
            }
            .store(in: &cancellables)
    }

    // MARK: - UI Setup

    private func setupCollectionView() {
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: ProgressLayout.createLayout()
        )
        collectionView.dataSource = self

        collectionView.register(
            ProgressCell.self,
            forCellWithReuseIdentifier: CustomElement.progressCell.rawValue
        )

        collectionView.register(
            HistoryHeaderView.self,
            forSupplementaryViewOfKind: CustomElement.historyHeader.rawValue,
            withReuseIdentifier: CustomElement.historyHeader.rawValue
        )

        collectionView.register(
            OutlineBackgroundView.self,
            forSupplementaryViewOfKind: CustomElement.outlineBackground.rawValue,
            withReuseIdentifier: CustomElement.outlineBackground.rawValue
        )

        view.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupEmptyStateView() {
        view.addSubview(emptyStateView)

        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            emptyStateView.heightAnchor.constraint(equalToConstant: 312)
        ])
        setupEmptyStateVisibility()
    }

    private func setupEmptyStateVisibility() {
        emptyStateView.isHidden = !viewModel.habitsProgress.isEmpty
    }

    // MARK: - Data Handling

    func updateData(for period: Period) {
        viewModel.selectedPeriod = period
    }
}
