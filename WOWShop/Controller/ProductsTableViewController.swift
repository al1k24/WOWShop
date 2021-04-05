//
//  ProductsTableViewController.swift
//  WOWShop
//
//  Created by Alik on 01.04.2021.
//

import UIKit

class ProductsTableViewController: UITableViewController {
    
    //MARK: - Properties
    
    private var products = [Product]() {
        didSet { self.tableView.reloadData() }
    }
    
    private let productsRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .wowShopBlue
        refreshControl.addTarget(self, action: #selector(refreshAllProducts), for: .valueChanged)
        return refreshControl
    }()
    
    private var currentOffestForLoading = 0
    
    private var isFetchingMore = false
    
    private lazy var fetchingMoreIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    //MARK: - Lifecycle
    
    deinit { print("* DEBUG: deinit -> ProductsTableViewController") }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchProducts(offset: currentOffestForLoading, limit: 5)
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        configureTableView()
        configureNavigation()
    }
    
    private func configureTableView() {
        tableView.refreshControl = productsRefreshControl
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .wowProductSeparatorGray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.reuseIdentifier)
    }
    
    private func configureNavigation() {
        let imageView = UIImageView(image: UIImage(named: "WOWLogo"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 72, height: 44)
        navigationItem.titleView = imageView
        
        navigationItem.backButtonTitle = ""
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "person"),
            style: .plain,
            target: self,
            action: nil
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(favoriteBarButtonTapped)
        )
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = .wowShopBlue
        navigationController?.navigationBar.isTranslucent = false
        
        //Link: - https://sarunw.com/posts/how-to-change-back-button-image/
        let backButtonImage = UIImage(systemName: "arrow.left")
        navigationController?.navigationBar.backIndicatorImage = backButtonImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
    }
    
    @objc private func favoriteBarButtonTapped() {
        let viewController = FavoriteProductsTableViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: - API
    
    private func fetchProducts(offset: Int, limit: Int) {
        NetworkService.shared.fetchProducts(offest: offset, limit: limit) { [weak self] (result) in
            switch result {
            case .failure(let error):
                if let error = error.errorDescription {
                    print("* Error: \(error)")
                }
            case .success(let products):
                if products.count > 0 {
                    self?.currentOffestForLoading += products.count

                    if offset == 0 {
                        self?.products = products
                    } else {
                        self?.products.append(contentsOf: products)
                    }
                }
            }
            self?.productsRefreshControl.endRefreshing()
            
            self?.isFetchingMore = false
        }
    }
    
}

//MARK: - Table view data source
extension ProductsTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.reuseIdentifier, for: indexPath) as! ProductTableViewCell
    
        let key = String(products[indexPath.row].id)
        
        cell.productDelegate = self
        cell.configure(with: products[indexPath.row],
                       isFavorite: UserDefaults.standard.bool(forKey: key))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let productId = products[indexPath.row].id
        let controller = ProductInfoController(productId: productId)
        navigationController?.pushViewController(controller, animated: true)
    }

}

//MARK: - Table view delegate
extension ProductsTableViewController {
    
    @objc private func refreshAllProducts() {
        currentOffestForLoading = 0
        
        fetchProducts(offset: currentOffestForLoading, limit: 5)
    }
    
    func reloadAll() {
        self.tableView.reloadData()
    }
}

//MARK: - Scroll view delegate
extension ProductsTableViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !isFetchingMore {
                startFetchMoreData()
            }
        }
    }
    
    private func startFetchMoreData() {
        isFetchingMore = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            if let offset = self?.currentOffestForLoading {
                self?.fetchProducts(offset: offset, limit: 3)
            }
        }
    }
}

extension ProductsTableViewController: ProductTableViewCellDelegate {
    
    func addToFavoriteButtonDidTapped(_ vc: UITableViewCell, didAddInFavorite favorite: Bool) {
        guard let indexPath = tableView.indexPath(for: vc) else { return }

        let key = String(products[indexPath.row].id)
        
        if !favorite {
            UserDefaults.standard.removeObject(forKey: key)
        } else {
            UserDefaults.standard.set(favorite, forKey: key)
        }
    }
}

//MARK: - SwiftUI View Previews
#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct ProductsTableViewController_Preview: PreviewProvider {

    static var previews: some View {
        ProductsTableViewController().toPreview()
            .edgesIgnoringSafeArea(.all)
    }
}
#endif
