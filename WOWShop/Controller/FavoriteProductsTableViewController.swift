//
//  FavoriteProductsTableViewController.swift
//  WOWShop
//
//  Created by Alik on 05.04.2021.
//

import UIKit

class FavoriteProductsTableViewController: UITableViewController {

    //MARK: - Lifecycle
    
    deinit { print("* DEBUG: deinit -> FavoriteProductsTableViewController") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        configureTableView()
        configureNavigation()
    }
    
    private func configureTableView() {
//        tableView.refreshControl = productsRefreshControl
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

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "heart.fill"),
            style: .plain,
            target: self,
            action: #selector(favoriteBarButtonTapped)
        )
    }
    
    @objc private func favoriteBarButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

}
