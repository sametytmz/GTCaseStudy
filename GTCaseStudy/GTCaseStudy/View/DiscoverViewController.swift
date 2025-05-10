//
//  DiscoverViewController.swift
//  GTCaseStudy
//
//  Created by Samet Yatmaz on 10.05.2025.
//

import UIKit

class DiscoverViewController: UIViewController {
    // MARK: - UI
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { section, environment in
            switch section {
            case 0:
                return NSCollectionLayoutSection.horizontalGrid(
                    itemFractionalWidth: 0.5,
                    itemHeight: 260,
                    groupFractionalWidth: 0.96,
                    interItemSpacing: 8,
                    contentInsets: NSDirectionalEdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8)
                )
            case 1:
                return NSCollectionLayoutSection.horizontalGrid(
                    itemFractionalWidth: 1.0/3.0,
                    itemHeight: 200,
                    groupFractionalWidth: 0.96,
                    interItemSpacing: 8,
                    contentInsets: NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 16, trailing: 8),
                    orthogonalScrolling: .continuous,
                    interGroupSpacing: 8
                )
            default:
                return NSCollectionLayoutSection.verticalGrid(
                    itemFractionalWidth: 0.5,
                    itemHeight: 320,
                    groupFractionalWidth: 1.0,
                    interItemSpacing: 8,
                    contentInsets: NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 16, trailing: 8),
                    interGroupSpacing: 8
                )
            }
        }
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(white: 0.97, alpha: 1)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(DiscoverCardCell.self, forCellWithReuseIdentifier: DiscoverCardCell.reuseIdentifier)
        return cv
    }()
    private let refreshControl = UIRefreshControl()
    // MARK: - ViewModel
    private let viewModel = DiscoverViewModel()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.97, alpha: 1)
        setupNavigationBar()
        setupCollectionView()
        bindViewModel()
        viewModel.fetchAllData()
    }
    private func setupNavigationBar() {
        title = NSLocalizedString("Home", comment: "")
        let avatar = UIImage(named: "avatarIcon") ?? UIImage()
        let avatarView = UIImageView(image: avatar)
        avatarView.contentMode = .scaleAspectFill
        avatarView.layer.cornerRadius = 16
        avatarView.clipsToBounds = true
        avatarView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        avatarView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        let barButton = UIBarButtonItem(customView: avatarView)
        navigationItem.leftBarButtonItem = barButton
    }
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor
        )
    }
    private func bindViewModel() {
        viewModel.onDataUpdate = { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.collectionView.reloadData()
        }
        viewModel.onError = { [weak self] error in
            self?.refreshControl.endRefreshing()
            self?.showAlert(title: NSLocalizedString("Error", comment: ""), message: error)
        }
    }
    @objc private func refreshData() {
        viewModel.fetchAllData(forceRefresh: true)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return viewModel.firstList.count
        case 1: return viewModel.secondList.count
        case 2: return viewModel.twoColumnList.count
        default: return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoverCardCell.reuseIdentifier, for: indexPath) as? DiscoverCardCell else {
            return UICollectionViewCell()
        }
        let item: DiscoverItem
        switch indexPath.section {
        case 0: item = viewModel.firstList[indexPath.item]
        case 1: item = viewModel.secondList[indexPath.item]
        case 2: item = viewModel.twoColumnList[indexPath.item]
        default: fatalError()
        }
        cell.configure(with: item, section: indexPath.section)
        return cell
    }
} 
