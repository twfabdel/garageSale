//
//  ImageSelectionViewController.swift
//  GarageSale
//
//  Created by Tarek Abdelghany on 11/21/17.
//  Copyright © 2017 Tarek Abdelghany. All rights reserved.
//

import UIKit
import CoreData

class ImageSelectionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var newSale: SaleModel?
    let imagePicker = UIImagePickerController()
    var items = [saleItem]()

    @IBOutlet weak var itemCollectionView: UICollectionView! {
        didSet {
            itemCollectionView.delegate = self
            itemCollectionView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
    }

    // MARK: - Navigation
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        newSale?.datePosted = Date()
        let managedObjectContext = newSale!.managedObjectContext!
        let entityItem = NSEntityDescription.entity(forEntityName: "ItemModel", in: managedObjectContext)
        items.forEach { saleItem in
            let newItem = ItemModel(entity: entityItem!, insertInto: managedObjectContext)
            let imgData = UIImageJPEGRepresentation(saleItem.image, 0.8)
            newItem.image = imgData
            if let price = saleItem.price {
                newItem.price = price
            }
            newSale?.addToItems(newItem)
        }
        do {
            try self.newSale!.managedObjectContext!.save()
            print("successfully saved data")
            resetView()
        } catch {
            print("Error saving data: \(error.localizedDescription)")
        }
    }
    
    private func resetView() {
        self.tabBarController?.switchToTab(0, withAnimation: true)
        self.navigationController?.popToRootViewController(animated: false)
        if let mapVC = self.navigationController?.viewControllers.first as? LocationSelectionViewController {
            mapVC.setMapLocationToUser()
        }
    }
    
    // MARK: - Image Picker Delegate
    
    @IBAction func addImage(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            items.append(saleItem(image: image))
            self.itemCollectionView.reloadData()
        } else {
            print("Error selecting image")
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewItemCell", for: indexPath)
        if let itemCell = cell as? AddItemCollectionViewCell {
            let item = items[indexPath.row]
            itemCell.itemImageView.contentMode = .scaleAspectFill
            itemCell.itemImageView.image = item.image
            if let price = item.price {
                itemCell.priceTextField.text = "\(price)"
            }
        }
        return cell
    }
}

struct saleItem {
    var price: Float?
    var image: UIImage
    
    init(image: UIImage, price: Float? = nil) {
        self.image = image
        self.price = price
    }
}

extension UITabBarController {
    func switchToTab(_ index: Int, withAnimation animated: Bool) {
        if !animated {
            self.selectedIndex = index
            return
        }
        if let fromView = self.selectedViewController?.view, let toView = self.viewControllers?[index].view {
            UIView.transition(
                from: fromView,
                to: toView,
                duration: 0.60,
                options: .transitionCurlDown ,
                completion: { finished in
                    if finished {
                        self.selectedIndex = index
                    }
                }
            )
        }
    }
}
