//
//  MapSearchViewController.swift
//  GarageSale
//
//  Created by Tarek Abdelghany on 11/19/17.
//  Copyright © 2017 Tarek Abdelghany. All rights reserved.
//

import UIKit
import MapKit

class MapSearchViewController: UIViewController, CLLocationManagerDelegate, UISearchControllerDelegate {

    let manager = CLLocationManager()
    var resultSearchController: UISearchController!
    var map: MKMapView?
    
    var rightBarButton: UIBarButtonItem?
    var leftBarButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rightBarButton = navigationItem.rightBarButtonItem
        leftBarButton = navigationItem.leftBarButtonItem
        
        map?.showsUserLocation = true
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        setMapLocationToUser()
        
        initializeSearchTable()
    }
    
    // MARK: - Search Controller and Table Initialization
    
    func willDismissSearchController(_ searchController: UISearchController) {
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
    }
    
    /* Search table design adapted from
     * https://www.thorntech.com/2016/01/how-to-search-for-location-using-apples-mapkit/
     */
    
    var searchBarPlaceholder = "Search for garage sales near:"
    private func initializeSearchTable() {
        if let saleSearchTable = storyboard?.instantiateViewController(withIdentifier: "MapSearchTable") as? MapSearchTableViewController {
            resultSearchController = UISearchController(searchResultsController: saleSearchTable)
            resultSearchController.searchResultsUpdater = saleSearchTable
            resultSearchController.delegate = self
            
            let searchBar = resultSearchController!.searchBar
            searchBar.sizeToFit()
            searchBar.placeholder = searchBarPlaceholder
            
            if let textField = searchBar.value(forKey: "_searchField") as? UITextField {
                textField.backgroundColor = GlobalConstants.darkPrimaryColor
                textField.textColor = GlobalConstants.barTextColor
            }
            
            navigationItem.titleView = resultSearchController?.searchBar
            resultSearchController.hidesNavigationBarDuringPresentation = false
            resultSearchController.dimsBackgroundDuringPresentation = true
            definesPresentationContext = true
            
            saleSearchTable.mapView = map
            saleSearchTable.locationSelectionClosure = setMapLocationTo(_:user:)
        }
    }
    
    // MARK: - Map and location
    
    func setMapLocationToUser() {
        if let location = manager.location {
            let span = MKCoordinateSpan(latitudeDelta: MapConstants.mapSpan, longitudeDelta: MapConstants.mapSpan)
            let locationCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            map?.setRegion(MKCoordinateRegion(center: locationCoordinate, span: span), animated: true)
        }
    }
    
    func setMapLocationTo(_ placemark: MKPlacemark?, user isUser: Bool) {
        resultSearchController.isActive = false
        if isUser {
            setMapLocationToUser()
        } else {
            let span = MKCoordinateSpan(latitudeDelta: MapConstants.mapSpan, longitudeDelta: MapConstants.mapSpan)
            if let center = placemark?.location?.coordinate {
                let region = MKCoordinateRegion(center: center, span: span)
                map?.setRegion(region, animated: true)
            }
        }
    }
    
    struct MapConstants {
        static let pinSizeRatio: CGFloat = 0.05
        static let mapSpan = 0.025
    }
}
