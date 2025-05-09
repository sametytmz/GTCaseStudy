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
        contentView.addSubview(priceLabel)
        contentView.addSubview(oldPriceLabel)
        contentView.addSubview(discountLabel)
        contentView.addSubview(ratingStack)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            oldPriceLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            oldPriceLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 8),
            discountLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            discountLabel.leadingAnchor.constraint(equalTo: oldPriceLabel.trailingAnchor, constant: 8),
            discountLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8),
            ratingStack.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4),
            ratingStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            ratingStack.heightAnchor.constraint(equalToConstant: 16),
            ratingStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    // MARK: - Configure
    func configure(with item: DiscoverItem) {
        titleLabel.text = item.title
        if let price = item.price {
            priceLabel.text = price
            priceLabel.isHidden = false
        } else {
            priceLabel.isHidden = true
        }
        if let oldPrice = item.oldPrice {
            let attributed = NSAttributedString(string: oldPrice, attributes: [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: UIColor.appGray
            ])
            oldPriceLabel.attributedText = attributed
            oldPriceLabel.isHidden = false
        } else {
            oldPriceLabel.isHidden = true
        }
        if let discount = item.discount {
            discountLabel.text = discount
            discountLabel.isHidden = false
        } else {
            discountLabel.isHidden = true
        }
        if let rating = item.rating {
            setRating(rating)
            ratingStack.isHidden = false
        } else {
            ratingStack.isHidden = true
        }
        // Görsel yükleme (placeholder)
        if let urlString = item.imageUrl, let url = URL(string: urlString) {
            // Basit bir image loader (gelişmişi için SDWebImage vs. kullanılabilir)
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
        let fullStars = Int(rating)
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
