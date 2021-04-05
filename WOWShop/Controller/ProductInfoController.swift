//
//  ProductController.swift
//  WOWShop
//
//  Created by Alik on 02.04.2021.
//

import UIKit

class ProductInfoController: UIViewController {
    
    //MARK: - Properties
    
    private var productId: Int
    
    private var productFavoriteStatus = false
    
    private let scrollViewRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .wowShopBlue
        refreshControl.addTarget(self, action: #selector(refreshProduct), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setDimensions(width: 40, height: 40)
//        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.frame = self.view.bounds
        scrollView.autoresizingMask = .flexibleHeight
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.bounces = true
        return scrollView
    }()
    
    private let footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let productImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "NoImage")
        return imageView
    }()

    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .wowProductNameBlue
        label.font = UIFont(name: "OpenSans-ExtraBold", size: 24)
        label.text = "Product Name"
        return label
    }()
    
    private let informationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .wowProductNameBlue
        label.font = UIFont(name: "OpenSans-ExtraBold", size: 24)
        label.text = "INFORMATION"
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
        label.text = "Product price"
        label.textColor = .black
        return label
    }()
    
    private let productFullDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .justified
        label.text = "Product description"
        label.textColor = .wowProductDescriptionGray
        label.font = UIFont(name: "OpenSans-Regular", size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .wowAddToCartButtonBlue
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "OpenSans-Bold", size: 14)
        button.setTitle("ADD TO CART", for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    private lazy var buyNowButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .wowBuyNowButtonPurple
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "OpenSans-Bold", size: 14)
        button.setTitle("BUY NOW", for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .wowProductSeparatorGray
        return view
    }()
    
    //MARK: - Lifecycle
    
    deinit { print("* DEBUG: deinit -> ProductInfoController") }
    
    init(productId: Int) {
        self.productId = productId
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        fetchProduct(with: productId)
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        contentScrollView.delegate = self
        contentScrollView.refreshControl = scrollViewRefreshControl
        
        view.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(named: "WOWLogo"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 72, height: 44)
        navigationItem.titleView = imageView
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(favoriteBarButtonTapped)
        )
        
        navigationItem.backButtonTitle = ""
        
        #if DEBUG
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = .wowShopBlue
        navigationController?.navigationBar.isTranslucent = false
        #endif
        
        view.addSubview(contentScrollView)
        contentScrollView.anchor(top: view.topAnchor,
                                 left: view.leftAnchor,
                                 right: view.rightAnchor)
        
        contentScrollView.addSubview(favoriteButton)
        favoriteButton.anchor(top: contentScrollView.topAnchor,
                              right: view.rightAnchor,
                              paddingTop: 24,
                              paddingRight: 16)
        
        contentScrollView.addSubview(productImageView)
        productImageView.centerX(inView: contentScrollView,
                                 topAnchor: contentScrollView.topAnchor,
                                 paddingTop: 48)
        productImageView.setDimensions(width: 300, height: 300)

        contentScrollView.addSubview(productNameLabel)
        productNameLabel.anchor(top: productImageView.bottomAnchor,
                                left: view.leftAnchor,
                                right: view.rightAnchor,
                                paddingTop: 32, paddingLeft: 32, paddingRight: 32)

        contentScrollView.addSubview(productDescriptionLabel)
        productDescriptionLabel.anchor(top: productNameLabel.bottomAnchor,
                                       left: view.leftAnchor,
                                       right: view.rightAnchor,
                                       paddingTop: 8, paddingLeft: 32, paddingRight: 32)

        contentScrollView.addSubview(productPriceLabel)
        productPriceLabel.anchor(top: productDescriptionLabel.bottomAnchor,
                                 left: view.leftAnchor,
                                 right: view.rightAnchor,
                                 paddingTop: 8, paddingLeft: 32, paddingRight: 32)
        
        contentScrollView.addSubview(underlineView)
        underlineView.anchor(top: productPriceLabel.bottomAnchor,
                             left: view.leftAnchor,
                             right: view.rightAnchor,
                             paddingTop: 32, paddingLeft: 32, paddingRight: 32, height: 1)
        
        contentScrollView.addSubview(informationLabel)
        informationLabel.anchor(top: underlineView.bottomAnchor,
                                left: view.leftAnchor,
                                paddingTop: 32, paddingLeft: 32)
        
        contentScrollView.addSubview(productFullDescriptionLabel)
        productFullDescriptionLabel.anchor(top: informationLabel.bottomAnchor,
                                           left: view.leftAnchor,
                                           bottom: contentScrollView.bottomAnchor,
                                           right: view.rightAnchor,
                                           paddingTop: 16, paddingLeft: 32, paddingBottom: 32, paddingRight: 32)
        
        view.addSubview(footerView)
        footerView.anchor(top: contentScrollView.bottomAnchor,
                          left: view.leftAnchor,
                          bottom: view.safeAreaLayoutGuide.bottomAnchor,
                          right: view.rightAnchor,
                          height: 80)
        
        let stack = UIStackView(arrangedSubviews: [addToCartButton, buyNowButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        
        footerView.addSubview(stack)
        stack.anchor(top: footerView.topAnchor,
                     left: footerView.leftAnchor,
                     bottom: footerView.bottomAnchor,
                     right: footerView.rightAnchor,
                     paddingTop: 16, paddingLeft: 24, paddingBottom: 16, paddingRight: 24)
        
        let safeAreaView = UIView()
        safeAreaView.backgroundColor = .white
        view.addSubview(safeAreaView)
        safeAreaView.anchor(top: footerView.bottomAnchor,
                        left: view.leftAnchor,
                        bottom: view.bottomAnchor,
                        right: view.rightAnchor)
        
        footerView.layer.shadowColor = UIColor.systemGray.cgColor
        footerView.layer.shadowOpacity = 0.5
        footerView.layer.shadowOffset = .zero
        footerView.layer.shadowRadius = 25
        
        footerView.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
        footerView.layer.shouldRasterize = true
        footerView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    private func configure(with product: Product) {
        productNameLabel.text = product.title
        productFullDescriptionLabel.text = product.details
        productDescriptionLabel.text = product.shortDescription
        productPriceLabel.attributedText = Utilities().attributetPrice(for: product.price, and: product.salePercent)

        productImageView.set(imageURL: product.image)
        
        let key = String(productId)
        productFavoriteStatus = UserDefaults.standard.bool(forKey: key)
        updateFavoriteIcon(productFavoriteStatus)
    }
    
    private func updateFavoriteIcon(_ isFavorite: Bool) {
        let configuration = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 30))
        let systemIcon = isFavorite ? "heart.fill" : "heart"
        let image = UIImage(systemName: systemIcon, withConfiguration: configuration)
        favoriteButton.setImage(image, for: .normal)
        favoriteButton.tintColor = .wowFavoriteButtonRed
    }
    
    @objc private func favoriteButtonTapped() {
        productFavoriteStatus = !productFavoriteStatus
        
        updateFavoriteIcon(productFavoriteStatus)
        
        guard let window = UIWindow.key else { return }
        guard let tableView = window.rootViewController as? ProductsTableViewController else { return }
        
        tableView.reloadAll()
    }
    
    @objc private func favoriteBarButtonTapped() {
        let viewController = FavoriteProductsTableViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: - API
    
    private func fetchProduct(with id: Int) {
        NetworkService.shared.fetchProduct(id: id) { [weak self] (result) in
            switch result {
            case .failure(let error):
                if let error = error.errorDescription {
                    print("* Error: \(error)")
                }
            case .success(let product):
                self?.configure(with: product)
            }
            
            self?.scrollViewRefreshControl.endRefreshing()
        }
    }
}

extension ProductInfoController: UIScrollViewDelegate {
    
    @objc func refreshProduct() {
        fetchProduct(with: productId)
    }
}


//MARK: - SwiftUI View Previews
#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct ProductInfoController_Preview: PreviewProvider {
    
    static var previews: some View {
        ProductInfoController(productId: 0).toPreview()
            .edgesIgnoringSafeArea(.all)
    }
}
#endif
