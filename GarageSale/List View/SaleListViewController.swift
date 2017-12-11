//
//  SaleListViewController.swift
//  GarageSale
//
//  Created by Tarek Abdelghany on 11/17/17.
//  Copyright © 2017 Tarek Abdelghany. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class SaleListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    // MARK: - Core Data Loading
    
    var managedObjectContext: NSManagedObjectContext!
    var loadedGarageSales = [SaleModel]()
    var filteredGarageSales = [SaleModel]()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareSearchBar()
        managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters

        formatButtons()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        sortButtonTapped(imageButtons[0])
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
    
    // MARK: - Sort Buttons
    
    @IBOutlet var imageButtons: [UIButton]!
    @IBOutlet var titleButtons: [UIButton]!
    
    private func formatButtons() {
        imageButtons.forEach{
            $0.tintColor = .black
        }
        titleButtons.forEach{
            $0.setTitleColor(GlobalConstants.primaryColor, for: .disabled)
            $0.setTitleColor(.black, for: .normal)
        }
    }
    
    private func getSortFunction(for index: Int) -> ((SaleModel, SaleModel)->Bool)? {
        switch index {
        case 0:
            return { (one, two) -> Bool in
                guard let date1 = one.date, let date2 = two.date
                    else { return false }
                return date1.compare(date2) == .orderedAscending
            }
        case 1:
            return { (one, two) -> Bool in
                guard let date1 = one.datePosted, let date2 = two.datePosted
                    else { return false }
                return date1.compare(date2) == .orderedDescending
            }
        case 2:
            return { (one, two) -> Bool in
                guard let currentLocation = self.locationManager.location
                    else { return false }
                let loc1 = CLLocation(latitude: one.latitude, longitude: one.longitude)
                let loc2 = CLLocation(latitude: two.latitude, longitude: two.longitude)
                return loc1.distance(from: currentLocation) < loc2.distance(from: currentLocation)
            }
        case 3:
            return { (one, two) -> Bool in
                guard let items1 = one.items?.allObjects as? [ItemModel],
                let items2 = two.items?.allObjects as? [ItemModel]
                    else {  return false }
                if items1.count == 0 { return false }
                if items2.count == 0 { return true }
                var sum1: Float = 0
                for item in items1 {
                    sum1 += item.price
                }
                var sum2: Float = 0
                for item in items2 {
                    sum2 += item.price
                }
                return sum1/(Float(items1.count)) < sum2/Float(items2.count)
            }
        default:
            return nil
        }
    }

    @IBAction func sortButtonTapped(_ sender: UIButton) {
        if let titleIndex = titleButtons.index(of: sender) {
            sortButtonTapped(imageButtons[titleIndex])
            return
        }
        guard let index = imageButtons.index(of: sender) else { return }
        
        for i in 0..<imageButtons.count {
            if i == index {
                imageButtons[i].tintColor = GlobalConstants.primaryColor
                imageButtons[i].isUserInteractionEnabled = false
                titleButtons[i].isEnabled = false
            } else {
                imageButtons[i].tintColor = .black
                imageButtons[i].isUserInteractionEnabled = true
                titleButtons[i].isEnabled = true
            }
        }
        
        if let sortFunction = getSortFunction(for: index) {
            filteredGarageSales = filteredGarageSales.sorted(by: sortFunction)
        }
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
