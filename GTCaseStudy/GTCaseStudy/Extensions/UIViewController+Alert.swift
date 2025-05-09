//
//  UIViewController+Alert.swift
//  GTCaseStudy
//
//  Created by Samet Yatmaz on 10.05.2025.
//

import UIKit

extension UIViewController {
    func showComingSoonAlert() {
        let alert = UIAlertController(
            title: NSLocalizedString("Coming Soon", comment: ""),
            message: NSLocalizedString("Bu özellik yakında eklenecek.", comment: ""),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
        present(alert, animated: true)
    }
} 
