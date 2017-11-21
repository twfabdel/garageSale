//
//  SaleListViewController.swift
//  GarageSale
//
//  Created by Tarek Abdelghany on 11/17/17.
//  Copyright © 2017 Tarek Abdelghany. All rights reserved.
//

import UIKit
import CoreData

class SaleListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Core Data Loading
    
    var managedObjectContext: NSManagedObjectContext!
    var garageSales = [SaleModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.saleTableView.reloadData()
    }
    
    private func loadData() {
        let saleRequest: NSFetchRequest<SaleModel> = SaleModel.fetchRequest()
        
        do {
            garageSales = try managedObjectContext.fetch(saleRequest)
            self.saleTableView.reloadData()
        } catch {
            print("Could not load data: \(error.localizedDescription)")
        }
    }
    
    
    // MARK: - Table View Data
    
    @IBOutlet weak var saleTableView: UITableView! {
        didSet {
            saleTableView.delegate = self
            saleTableView.dataSource = self
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return garageSales.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = saleTableView.dequeueReusableCell(withIdentifier: "SaleCell")!
        
        if let saleCell = cell as? SaleListTableViewCell {
            let garageSale = garageSales[indexPath.row]
            saleCell.locationLabel.text = garageSale.address
            saleCell.dateLabel.text = garageSale.dateStart?.description
        }
    
        return cell
    }
    
    @IBAction func newGarageSale(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let navVC = storyboard.instantiateViewController(withIdentifier: "NewGarageSaleFlow") as? UINavigationController {
            if let locationVC = navVC.viewControllers.first as? LocationSelectionViewController {
                locationVC.creationCompletionHandler = { [weak self] in
                    self?.loadData()
                }
                self.present(navVC, animated: true, completion: nil)
            }
        }
    }

}
