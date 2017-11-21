//
//  SaleMapViewController.swift
//  GarageSale
//
//  Created by Tarek Abdelghany on 11/17/17.
//  Copyright © 2017 Tarek Abdelghany. All rights reserved.
//

import UIKit
import MapKit

class SaleMapViewController: MapSearchViewController {//UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var saleMap: MKMapView!
//
//    let manager = CLLocationManager()
//    var resultSearchController: UISearchController!
    
    override func viewDidLoad() {
        super.map = saleMap
        super.viewDidLoad()
        
//        map.showsUserLocation = true
//
//        manager.delegate = self
//        manager.desiredAccuracy = kCLLocationAccuracyBest
//        manager.requestAlwaysAuthorization()
//        manager.startUpdatingLocation()
//        setMapLocationToUser()
//
//        initializeSearchTable()
    }
    
    
    /* Search table design adapted from
     * https://www.thorntech.com/2016/01/how-to-search-for-location-using-apples-mapkit/
     */
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
}
