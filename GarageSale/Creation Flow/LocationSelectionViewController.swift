//
//  LocationSelectionViewController.swift
//  GarageSale
//
//  Created by Tarek Abdelghany on 11/18/17.
//  Copyright © 2017 Tarek Abdelghany. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class LocationSelectionViewController: MapSearchViewController, MKMapViewDelegate {
    var newSale: GarageSale?
    let geocoder = CLGeocoder()
    
    @IBOutlet weak var newLocationMap: MKMapView! {
        didSet {
            newLocationMap.delegate = self
        }
    }
    @IBOutlet weak var addressLabel: UILabel!
    var addressIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        newSale = GarageSale()
        
        map = newLocationMap
        createMapPin()
        
        addressIndicator.activityIndicatorViewStyle = .gray
        addressIndicator.center = addressLabel.center
        addressIndicator.hidesWhenStopped = true
        self.view.addSubview(addressIndicator)
        
        super.searchBarPlaceholder = "Garage Sale Address:"
        super.viewDidLoad()
    }
    
    // MARK: - Map delegate and pin
    
    private func createMapPin() {
        let pinHeight = self.view.frame.height * MapConstants.pinSizeRatio
        let pinSize = CGSize(width: pinHeight, height: pinHeight)
        let pinX = newLocationMap.center.x - pinSize.width/2
        let pinY = newLocationMap.center.y - pinSize.height
        let rect = CGRect(origin: CGPoint(x: pinX, y: pinY) , size: pinSize)
        let iconView = UIImageView(frame: rect)
        iconView.image = #imageLiteral(resourceName: "blue_map_pin")
        iconView.backgroundColor = .clear
        self.view.addSubview(iconView)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let centerLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        addressIndicator.startAnimating()
        addressLabel.isHidden = true
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        weak var weakSelf = self
        geocoder.reverseGeocodeLocation(centerLocation, completionHandler: { placemarks, error in
            if let err = error {
                print("Error: \(err.localizedDescription)")
                weakSelf?.addressLabel.text = "Error finding address at pin"
            } else if let placemark = placemarks?.first {
                if placemark.inlandWater != nil || placemark.ocean != nil {
                    weakSelf?.addressLabel.text = "Please use a valid location on land"
                } else {
                    weakSelf?.addressLabel.text = placemark.addressString
                    weakSelf?.navigationItem.rightBarButtonItem?.isEnabled = true
                }
            }
            weakSelf?.addressLabel.isHidden = false
            weakSelf?.addressIndicator.stopAnimating()
        })
    }
    
    
     // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dateSelectionVC = segue.destination as? DateSelectionViewController, let mapView = map {
            newSale?.address = addressLabel.text
            newSale?.latitude = mapView.centerCoordinate.latitude
            newSale?.longitude = mapView.centerCoordinate.longitude
            //newSale?.id = UUID()
            
            dateSelectionVC.newSale = newSale
        }
     }
 
}
