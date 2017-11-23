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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let verificationVC = segue.destination as? VerifyDetailsViewController {
            verificationVC.items = items
            verificationVC.newSale = newSale
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier != "ToCreationVerification" {
            return false
        }
        var noNil = true
        items.forEach {
            if $0.price == nil {
                noNil = false
            }
        }
        return noNil
    }
    
    // MARK: - Image Picker Delegate
    
    @IBAction func addImage(_ sender: UIButton) {
        imagePicker.sourceType = .camera  //.photoLibrary
        //imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
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
            
            weak var weakSelf = self
            itemCell.priceEditedHandler = {
                if let priceString = itemCell.priceTextField.text, priceString != "" {
                    if let priceFloat = Float(priceString) {
                        itemCell.priceTextField.text = priceFloat.priceString
                        weakSelf?.items[indexPath.row].price = priceFloat
                    } else {
                        itemCell.priceTextField.text = ""
                    }
                }
            }
            if let price = item.price {
                itemCell.priceTextField.text = String(format: "$%.02f", price)
            } else {
                itemCell.priceTextField.text = ""
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
