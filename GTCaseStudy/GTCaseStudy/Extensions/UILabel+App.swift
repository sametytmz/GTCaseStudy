//
//  UILabel+App.swift
//  GTCaseStudy
//
//  Created by Samet Yatmaz on 10.05.2025.
//

import UIKit

extension UILabel {
    static func appLabel(font: UIFont, textColor: UIColor = .appDark, numberOfLines: Int = 0) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = textColor
        label.numberOfLines = numberOfLines
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
} 
