//
//  MainTabBarController.swift
//  GTCaseStudy
//
//  Created by Samet Yatmaz on 10.05.2025.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupTabs()
    }
    private func setupTabs() {
        // Discover
        let discoverVC = DiscoverViewController()
        let discoverNav = UINavigationController(rootViewController: discoverVC)
        discoverNav.tabBarItem = UITabBarItem(title: NSLocalizedString("Discover", comment: ""), image: UIImage(named: "discoverIcon"), tag: 0)
        // Book
        let bookVC = UIViewController()
        bookVC.view.backgroundColor = .white
        bookVC.tabBarItem = UITabBarItem(title: NSLocalizedString("Book", comment: ""), image: UIImage(named: "bookIcon"), tag: 1)
        // Cart
        let cartVC = UIViewController()
        cartVC.view.backgroundColor = .white
        cartVC.tabBarItem = UITabBarItem(title: NSLocalizedString("Cart", comment: ""), image: UIImage(named: "cartIcon"), tag: 2)
        // Favorite
        let favoriteVC = UIViewController()
        favoriteVC.view.backgroundColor = .white
        favoriteVC.tabBarItem = UITabBarItem(title: NSLocalizedString("Favorite", comment: ""), image: UIImage(named: "favoriteIcon"), tag: 3)
        // Profile
        let profileVC = UIViewController()
        profileVC.view.backgroundColor = .white
        profileVC.tabBarItem = UITabBarItem(title: NSLocalizedString("Profile", comment: ""), image: UIImage(named: "profileIcon"), tag: 4)
        viewControllers = [discoverNav, bookVC, cartVC, favoriteVC, profileVC]
    }
    // MARK: - UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let index = viewControllers?.firstIndex(of: viewController), index != 0 {
            self.showComingSoonAlert()
            return false
        }
        return true
    }
} 
