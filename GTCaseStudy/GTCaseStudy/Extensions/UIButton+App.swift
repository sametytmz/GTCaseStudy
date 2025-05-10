//
//  UIButton+App.swift
//  GTCaseStudy
//
//  Created by Samet Yatmaz on 10.05.2025.
//

import UIKit

extension UIButton {
    static func appButton(title: String, font: UIFont, titleColor: UIColor = .white, bgColor: UIColor = .appGreen, cornerRadius: CGFloat = 12) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = font
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = bgColor
        button.layer.cornerRadius = cornerRadius
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
} 
