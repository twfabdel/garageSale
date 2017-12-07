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
        loadData()
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
            saleCell.titleLabel.text = garageSale.title
            saleCell.dateLabel.text = garageSale.date?.shortDateString
            saleCell.addressLabel.text = garageSale.address
            
            saleCell.dateLabel.textColor = GlobalConstants.darkPrimaryColor
            saleCell.titleLabel.textColor = GlobalConstants.darkPrimaryColor
            saleCell.sale = garageSale
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
