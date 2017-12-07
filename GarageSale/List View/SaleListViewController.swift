//
//  SaleListViewController.swift
//  GarageSale
//
//  Created by Tarek Abdelghany on 11/17/17.
//  Copyright © 2017 Tarek Abdelghany. All rights reserved.
//

import UIKit
import CoreData

class SaleListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: - Core Data Loading
    
    var managedObjectContext: NSManagedObjectContext!
    var loadedGarageSales = [SaleModel]()
    var filteredGarageSales = [SaleModel]()
    
    @IBOutlet weak var sortOptionCollectionView: UICollectionView! {
        didSet {
            sortOptionCollectionView.delegate = self
            sortOptionCollectionView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareSearchBar()
        managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    private func loadData() {
        let saleRequest: NSFetchRequest<SaleModel> = SaleModel.fetchRequest()
        do {
            loadedGarageSales = try managedObjectContext.fetch(saleRequest)
            filteredGarageSales = loadedGarageSales
            self.saleTableView.reloadData()
        } catch {
            print("Could not load data: \(error.localizedDescription)")
        }
    }
    
    // MARK: - UISearchBar Delegate
    
    private func prepareSearchBar() {
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.placeholder = "Filter Garage Sales"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        let resignTap = UITapGestureRecognizer(target: self, action: #selector(tapDismissKeyboard(_:)))
        resignTap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(resignTap)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredGarageSales = loadedGarageSales
        } else {
            filteredGarageSales = loadedGarageSales.filter {
                return $0.title?.lowercased().range(of: searchText.lowercased()) != nil
            }
        }
        self.saleTableView.reloadData()
    }
    
    @objc private func tapDismissKeyboard(_ sender: UITapGestureRecognizer) {
        if let searchBar = navigationItem.titleView as? UISearchBar, sender.state == .ended
        {
            searchBarSearchButtonClicked(searchBar)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    // MARK: - Collection View Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SortIcons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SortOptionCell", for: indexPath)
        if let optionCell = cell as? SaleOptionCollectionViewCell {
            let iconEnum = SortIcons(rawValue: indexPath.item)
            optionCell.iconLabel.text = iconEnum?.getString()
            optionCell.iconImageView.image = iconEnum?.getImage()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        filteredGarageSales = filteredGarageSales.sorted(by: { first, second in
            guard let date1 = first.date, let date2 = second.date else { return false }
            return date1.compare(date2) == ComparisonResult.orderedAscending
        })
        saleTableView.reloadData()
    }
    
    
    // MARK: - Table View Data
    
    @IBOutlet weak var saleTableView: UITableView! {
        didSet {
            saleTableView.delegate = self
            saleTableView.dataSource = self
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredGarageSales.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = saleTableView.dequeueReusableCell(withIdentifier: "SaleCell")!
        
        if let saleCell = cell as? SaleListTableViewCell {
            let garageSale = filteredGarageSales[indexPath.row]
            saleCell.titleLabel.text = garageSale.title
            saleCell.dateLabel.text = garageSale.date?.shortDateString
            saleCell.addressLabel.text = garageSale.address
            
            saleCell.dateLabel.textColor = GlobalConstants.darkPrimaryColor
            saleCell.titleLabel.textColor = GlobalConstants.darkPrimaryColor
            saleCell.sale = garageSale
            saleCell.setImagePreview()
        }
    
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sourceCell = sender as? SaleListTableViewCell,
            let destination = segue.destination as? SaleDetailsViewController
        {
            destination.sale = sourceCell.sale
        }
    }
}
