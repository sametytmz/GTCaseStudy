//
//  UIFont+App.swift
//  GTCaseStudy
//
//  Created by Samet Yatmaz on 10.05.2025.
//

import UIKit

extension UIFont {
    static func appTitleFont() -> UIFont {
        return UIFont.systemFont(ofSize: 32, weight: .bold)
    }
    static func appTextFieldFont() -> UIFont {
        return UIFont.systemFont(ofSize: 18, weight: .regular)
    }
    static func appButtonFont() -> UIFont {
        return UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
    static func appSocialButtonFont() -> UIFont {
        return UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    static func appForgotFont() -> UIFont {
        return UIFont.systemFont(ofSize: 10, weight: .regular)
    }
} 
