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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = sale?.title
        
        addressLabel.text = sale?.address
        dateLabel.text = sale?.date?.dateString
        timeLabel.text = (sale?.timeStart?.timeString ?? "") + " - " + (sale?.timeEnd?.timeString ?? "")
        
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
