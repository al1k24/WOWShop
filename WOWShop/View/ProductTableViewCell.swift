//
//  ProductTableViewCell.swift
//  WOWShop
//
//  Created by Alik on 02.04.2021.
//

import UIKit

protocol ProductTableViewCellDelegate: class {
    func addToFavoriteButtonDidTapped(_ vc: UITableViewCell, didAddInFavorite favorite: Bool)
}

class ProductTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    weak var productDelegate: ProductTableViewCellDelegate?
    
    private var productFavoriteStatus = false

    private let productImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "NoImage")
        return imageView
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setDimensions(width: 40, height: 40)
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()

    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .wowProductNameBlue
        label.font = UIFont(name: "OpenSans-ExtraBold", size: 20)
        label.text = "Product Name"
        return label
    }()

    private let productDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Product description"
        label.textColor = .wowProductDescriptionGray
        label.font = UIFont(name: "OpenSans-Regular", size: 14)
        label.numberOfLines = 0
        return label
    }()

    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    //MARK: - Lifecycle
    
    deinit { print("* DEBUG: deinit -> ProductTableViewCell") }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        productImageView.killDataTask()
        configure(with: .none)
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .white
        selectionStyle = .none
        
        updateFavoriteIcon(false)
        
        contentView.addSubview(favoriteButton)
        favoriteButton.anchor(top: contentView.topAnchor,
                              right: contentView.rightAnchor,
                              paddingTop: 24,
                              paddingRight: 16)
        
        contentView.addSubview(productImageView)
        productImageView.centerX(inView: contentView, topAnchor: contentView.topAnchor, paddingTop: 48)
        productImageView.setDimensions(width: 200, height: 200)
        
        contentView.addSubview(productNameLabel)
        productNameLabel.anchor(top: productImageView.bottomAnchor,
                                left: contentView.leftAnchor, right: contentView.rightAnchor,
                                paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        contentView.addSubview(productDescriptionLabel)
        productDescriptionLabel.anchor(top: productNameLabel.bottomAnchor,
                                       left: contentView.leftAnchor,
                                       right: contentView.rightAnchor,
                                       paddingTop: 8, paddingLeft: 32, paddingRight: 32)
        
        contentView.addSubview(productPriceLabel)
        productPriceLabel.anchor(top: productDescriptionLabel.bottomAnchor,
                                 left: contentView.leftAnchor,
                                 bottom: contentView.bottomAnchor,
                                 right: contentView.rightAnchor,
                                 paddingTop: 8, paddingLeft: 32, paddingBottom: 16, paddingRight: 32)
    }
    
    private func updateFavoriteIcon(_ isFavorite: Bool) {
        let configuration = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 30))
        let systemIcon = isFavorite ? "heart.fill" : "heart"
        let image = UIImage(systemName: systemIcon, withConfiguration: configuration)
        favoriteButton.setImage(image, for: .normal)
        favoriteButton.tintColor = .wowFavoriteButtonRed
    }
    
    func configure(with product: Product?, isFavorite: Bool = false) {
        if let product = product {
            
            productFavoriteStatus = isFavorite
            
            updateFavoriteIcon(productFavoriteStatus)
            
            productImageView.set(imageURL: product.image)
            
            productNameLabel.text = product.title
            productDescriptionLabel.text = product.shortDescription
            productPriceLabel.attributedText = Utilities().attributetPrice(for: product.price, and: product.salePercent)
        } else {
            productImageView.image = #imageLiteral(resourceName: "NoImage")
            productNameLabel.text = "..."
            productPriceLabel.text = "..."
            productDescriptionLabel.text = "..."
            
            favoriteButton.setImage(nil, for: .normal)
        }
    }
    
    @objc private func favoriteButtonTapped() {
        productFavoriteStatus = !productFavoriteStatus
        
        updateFavoriteIcon(productFavoriteStatus)
        productDelegate?.addToFavoriteButtonDidTapped(self, didAddInFavorite: productFavoriteStatus)
    }
}

