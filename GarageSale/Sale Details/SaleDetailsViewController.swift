//
//  SaleDetailsViewController.swift
//  GarageSale
//
//  Created by Tarek Abdelghany on 11/23/17.
//  Copyright © 2017 Tarek Abdelghany. All rights reserved.
//

import UIKit
import MapKit

class SaleDetailsViewController: UIViewController {
    
    var sale: SaleModel?
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var itemCountLabel: PaddedLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = sale?.title
        
        addressLabel.text = sale?.address
        dateLabel.text = sale?.date?.dateString
        timeLabel.text = timeRangeString(sale?.timeStart, to: sale?.timeEnd)
        
        setMapLocation()
        setImagePreview()
        mapView.isUserInteractionEnabled = false
    }
    
    // MARK: - Map and location
    
    private func setMapLocation() {
        if let sale = sale {
            let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
            let locationCoordinate = CLLocationCoordinate2D(latitude: sale.latitude, longitude: sale.longitude)
            
            mapView?.setRegion(MKCoordinateRegion(center: locationCoordinate, span: span), animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = locationCoordinate
            mapView.addAnnotation(annotation)
        }
    }
    
    // MARK: - Image Preview
    
    private func setImagePreview() {
        if let imageData = (sale?.items?.allObjects.first as? ItemModel)?.image {
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            let image = UIImage(data: imageData)
            imageView.image = image
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(showItemImages(_:)))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tap)
        }
        
        setItemCountLabel()
    }
    
    private func setItemCountLabel() {
        guard let count = sale?.items?.count else { return }
        var labelText = "\(count) Featured Item"
        if count > 1 {
            labelText += "s"
        }
        itemCountLabel.text = labelText
        itemCountLabel.backgroundColor = GlobalConstants.labelBackgroundColor
        itemCountLabel.layer.cornerRadius = GlobalConstants.labelCornerRadius
        itemCountLabel.layer.masksToBounds = true
    }
    
    @objc private func showItemImages(_ sender: UITapGestureRecognizer) {
        if sender.state != .ended {
            return
        }
        
        print("show items tap")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let itemImageVC = storyboard.instantiateViewController(withIdentifier: "SaleItemImages") as? ItemImagesViewController {
            itemImageVC.saleItems = sale?.items?.allObjects
            present(itemImageVC, animated: true, completion: nil)
        }
    }
}
