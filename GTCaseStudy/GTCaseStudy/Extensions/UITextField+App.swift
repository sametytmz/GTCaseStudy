//
//  UITextField+App.swift
//  GTCaseStudy
//
//  Created by Samet Yatmaz on 10.05.2025.
//

import UIKit

extension UITextField {
    static func appTextField(placeholder: String, font: UIFont, isSecure: Bool = false, icon: UIImage? = nil) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.font = font
        tf.isSecureTextEntry = isSecure
        tf.autocapitalizationType = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        if let icon = icon {
            let iconView = UIImageView(image: icon)
            iconView.contentMode = .scaleAspectFit
            iconView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            tf.rightView = iconView
            tf.rightViewMode = .always
        }
        return tf
    }
} 
