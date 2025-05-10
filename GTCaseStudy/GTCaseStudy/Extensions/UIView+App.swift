//
//  UIView+App.swift
//  GTCaseStudy
//
//  Created by Samet Yatmaz on 10.05.2025.
//

import UIKit

extension UIView {
    /// Birden fazla alt view'ı tek seferde ekler
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
    
    /// Kenarlardan başka bir view'a sabitler
    func pin(to view: UIView, insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom)
        ])
    }
    /// Sadece gerekli anchor'lara constraint ekler
    @discardableResult
    func anchor(
        top: NSLayoutYAxisAnchor? = nil,
        leading: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        trailing: NSLayoutXAxisAnchor? = nil,
        centerX: NSLayoutXAxisAnchor? = nil,
        centerY: NSLayoutYAxisAnchor? = nil,
        padding: UIEdgeInsets = .zero,
        size: CGSize = .zero
    ) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        if let top = top {
            constraints.append(topAnchor.constraint(equalTo: top, constant: padding.top))
        }
        if let leading = leading {
            constraints.append(leadingAnchor.constraint(equalTo: leading, constant: padding.left))
        }
        if let bottom = bottom {
            constraints.append(bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom))
        }
        if let trailing = trailing {
            constraints.append(trailingAnchor.constraint(equalTo: trailing, constant: -padding.right))
        }
        if let centerX = centerX {
            constraints.append(centerXAnchor.constraint(equalTo: centerX))
        }
        if let centerY = centerY {
            constraints.append(centerYAnchor.constraint(equalTo: centerY))
        }
        if size.width > 0 {
            constraints.append(widthAnchor.constraint(equalToConstant: size.width))
        }
        if size.height > 0 {
            constraints.append(heightAnchor.constraint(equalToConstant: size.height))
        }
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
    func setHeight(_ height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    func setWidth(_ width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
}

extension UIStackView {
    /// Birden fazla arrangedSubview'ı tek seferde ekler
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { self.addArrangedSubview($0) }
    }
}

extension NSCollectionLayoutSection {
    /// Yatay grid section oluşturur
    static func horizontalGrid(itemFractionalWidth: CGFloat, itemHeight: CGFloat, groupFractionalWidth: CGFloat, interItemSpacing: CGFloat, contentInsets: NSDirectionalEdgeInsets, orthogonalScrolling: UICollectionLayoutSectionOrthogonalScrollingBehavior = .continuous, interGroupSpacing: CGFloat = 0) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemFractionalWidth), heightDimension: .estimated(itemHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .zero
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionalWidth), heightDimension: .estimated(itemHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: Int(1.0/itemFractionalWidth))
        group.interItemSpacing = .fixed(interItemSpacing)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = orthogonalScrolling
        section.contentInsets = contentInsets
        section.interGroupSpacing = interGroupSpacing
        return section
    }
    /// Dikey grid section oluşturur
    static func verticalGrid(itemFractionalWidth: CGFloat, itemHeight: CGFloat, groupFractionalWidth: CGFloat, interItemSpacing: CGFloat, contentInsets: NSDirectionalEdgeInsets, interGroupSpacing: CGFloat = 0) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemFractionalWidth), heightDimension: .estimated(itemHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .zero
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionalWidth), heightDimension: .estimated(itemHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: Int(1.0/itemFractionalWidth))
        group.interItemSpacing = .fixed(interItemSpacing)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = contentInsets
        section.interGroupSpacing = interGroupSpacing
        return section
    }
} 
