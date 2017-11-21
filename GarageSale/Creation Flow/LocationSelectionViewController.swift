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

class LocationSelectionViewController: MapSearchViewController, MKMapViewDelegate {

//    var creationCompletionHandler: (()->Void)?
    let geocoder = CLGeocoder()
    
//    @IBAction func cancel(_ sender: UIBarButtonItem) {
//        self.dismiss(animated: true, completion: nil)
//    }
    
    @IBOutlet weak var newLocationMap: MKMapView! {
        didSet {
            newLocationMap.delegate = self
        }
    }
    @IBOutlet weak var addressLabel: UILabel!
    var addressIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        map = newLocationMap
        createMapPin()
        
        addressIndicator.activityIndicatorViewStyle = .gray
        addressIndicator.center = addressLabel.center
        addressIndicator.hidesWhenStopped = true
        self.view.addSubview(addressIndicator)
        
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
            dateSelectionVC.address = addressLabel.text
            dateSelectionVC.latitude = mapView.centerCoordinate.latitude
            dateSelectionVC.longitude = mapView.centerCoordinate.longitude
            //dateSelectionVC.creationCompletionHandler = creationCompletionHandler
        }
     }
 
}

extension CLPlacemark {
    var addressString: String {
        var address = append(subThoroughfare, to: "")
        address = append(thoroughfare, to: address, with: " ")
        address = append(locality, to: address, with: ", ")
        address = append(administrativeArea, to: address, with: ", ")
        return address
    }
    
    private func append(_ str: String?, to address: String, with delimiter: String = "") -> String {
        if str == nil {
            return address
        }
        if address.isEmpty {
            return str!
        }
        return address + delimiter + str!
    }
    
    private func addComma(to string: String) -> String {
        if string.count == 0 {
            return string
        }
        if string.suffix(2) == ", " {
            return string
        }
        return string + ", "
    }
    
    private func addSpace(to string: String) -> String {
        if string.count == 0 {
            return string
        }
        if string.suffix(1) == " " {
            return string
        }
        return string + " "
    }
}

//
//    let manager = CLLocationManager()
//    var resultSearchController: UISearchController!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        map.showsUserLocation = true
//
//        manager.delegate = self
//        manager.desiredAccuracy = kCLLocationAccuracyBest
//        manager.requestAlwaysAuthorization()
//        manager.startUpdatingLocation()
//        setMapLocationToUser()
//
//        initializeSearchTable()
//    }
//
//
//    /* Search table design adapted from
//     * https://www.thorntech.com/2016/01/how-to-search-for-location-using-apples-mapkit/
//     */
//    private func initializeSearchTable() {
//        if let saleSearchTable = storyboard?.instantiateViewController(withIdentifier: "MapSearchTable") as? MapSearchTableViewController {
//            resultSearchController = UISearchController(searchResultsController: saleSearchTable)
//            resultSearchController.searchResultsUpdater = saleSearchTable
//
//            let searchBar = resultSearchController!.searchBar
//            searchBar.sizeToFit()
//            searchBar.placeholder = "Search for garage sales near:"
//
//            navigationItem.titleView = resultSearchController?.searchBar
//            resultSearchController.hidesNavigationBarDuringPresentation = false
//            resultSearchController.dimsBackgroundDuringPresentation = true
//            definesPresentationContext = true
//
//            saleSearchTable.mapView = map
//            saleSearchTable.locationSelectionClosure = setMapLocationTo(_:user:)
//        }
//    }
//
//    // MARK: - Map and location
//
//    func setMapLocationToUser() {
//        if let location = manager.location {
//            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//            let locationCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//
//            map.setRegion(MKCoordinateRegion(center: locationCoordinate, span: span), animated: true)
//        }
//    }
//
//    func setMapLocationTo(_ placemark: MKPlacemark?, user isUser: Bool) {
//        resultSearchController.dismiss(animated: true, completion: nil)
//        resultSearchController.isActive = false
//        if isUser {
//            setMapLocationToUser()
//        } else {
//            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//            if let center = placemark?.location?.coordinate {
//                let region = MKCoordinateRegion(center: center, span: span)
//                map.setRegion(region, animated: true)
//            }
//        }
//    }
    
    
    
    
    
    



//}
