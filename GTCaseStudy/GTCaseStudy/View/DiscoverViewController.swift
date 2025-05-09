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
        let layout = UICollectionViewCompositionalLayout { section, _ in
            switch section {
            case 0:
                // 2'li yatay scroll
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(220))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8)
                return section
            case 1:
                // 3'lü yatay scroll
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(200))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 16, trailing: 8)
                return section
            default:
                // 2'li grid
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(260))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(260))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 16, trailing: 8)
                return section
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
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
        cell.configure(with: item)
        return cell
    }
} 
