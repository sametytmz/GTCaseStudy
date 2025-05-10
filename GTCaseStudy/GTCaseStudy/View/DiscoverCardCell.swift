//
//  DiscoverCardCell.swift
//  GTCaseStudy
//
//  Created by Samet Yatmaz on 10.05.2025.
//

import UIKit

class DiscoverCardCell: UICollectionViewCell {
    static let reuseIdentifier = "DiscoverCardCell"
    
    // MARK: - UI
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .semibold)
        l.textColor = .appDark
        l.numberOfLines = 2
        l.lineBreakMode = .byTruncatingTail
        l.minimumScaleFactor = 0.8
        l.adjustsFontSizeToFitWidth = true
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    private let priceLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .bold)
        l.textColor = .appDark
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    private let oldPriceLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .regular)
        l.textColor = .appGray
        l.attributedText = nil
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    private let discountLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .regular)
        l.textColor = UIColor.systemPink
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    private let ratingStack: UIStackView = {
        let s = UIStackView()
        s.axis = .horizontal
        s.spacing = 2
        s.alignment = .center
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    private let oldPriceRowStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.08
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        contentView.layer.shadowRadius = 8
        contentView.layer.masksToBounds = false
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(mainStack)
        mainStack.addArrangedSubview(priceLabel)
        mainStack.addArrangedSubview(oldPriceRowStack)
        mainStack.addArrangedSubview(ratingStack)
        oldPriceRowStack.addArrangedSubview(oldPriceLabel)
        oldPriceRowStack.addArrangedSubview(discountLabel)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            mainStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    // MARK: - Configure
    func configure(with item: DiscoverItem) {
        titleLabel.text = item.description
        if let price = item.price {
            priceLabel.text = String(format: "%.2f %@", price.value, price.currency)
            priceLabel.isHidden = false
        } else {
            priceLabel.isHidden = true
        }
        if let oldPrice = item.oldPrice {
            let oldPriceText = String(format: "%.2f %@", oldPrice.value, oldPrice.currency)
            let attributed = NSAttributedString(string: oldPriceText, attributes: [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: UIColor.appGray
            ])
            oldPriceLabel.attributedText = attributed
            oldPriceLabel.isHidden = false
        } else {
            oldPriceLabel.isHidden = true
        }
        if let discount = item.discount, !discount.isEmpty {
            discountLabel.text = discount
            discountLabel.isHidden = false
        } else {
            discountLabel.isHidden = true
        }
        oldPriceRowStack.isHidden = oldPriceLabel.isHidden && discountLabel.isHidden
        if let rating = item.ratePercentage {
            setRating(Double(rating) / 20.0)
            ratingStack.isHidden = false
        } else {
            ratingStack.isHidden = true
        }
        // Görsel yükleme (placeholder)
        if let urlString = item.imageUrl, let url = URL(string: urlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(named: "placeholder")
                    }
                }
            }
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
    }
    private func setRating(_ rating: Double) {
        ratingStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let fullStars = Int(round(rating))
        for i in 0..<5 {
            let imageName = i < fullStars ? "star_filled" : "star_empty"
            let star = UIImageView(image: UIImage(named: imageName))
            star.contentMode = .scaleAspectFit
            star.widthAnchor.constraint(equalToConstant: 16).isActive = true
            star.heightAnchor.constraint(equalToConstant: 16).isActive = true
            ratingStack.addArrangedSubview(star)
        }
    }
} 
