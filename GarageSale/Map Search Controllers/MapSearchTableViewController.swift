//
//  MapSearchTableViewController.swift
//  GarageSale
//
//  Created by Tarek Abdelghany on 11/17/17.
//  Copyright © 2017 Tarek Abdelghany. All rights reserved.
//

import UIKit
import MapKit

class MapSearchTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var mapView: MKMapView?
    var searchResultList = [MKMapItem]()
    
    /* Update Search controller code adapted from
     * https://www.thorntech.com/2016/01/how-to-search-for-location-using-apples-mapkit/
     */
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.searchResultList = response.mapItems
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return searchResultList.count
        default:
            break
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MapSearchResultCell", for: indexPath)
        
        if indexPath.section == 0 {
            cell.textLabel?.text = "Current Location"
        } else {
            let placemark = searchResultList[indexPath.row].placemark
            cell.textLabel?.text = placemark.name ?? placemark.title ?? "?"
        }

        return cell
    }
 
    
    var locationSelectionClosure: ((MKPlacemark?, Bool) -> Void)?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            locationSelectionClosure?(nil, true)
        case 1:
            let placemark = searchResultList[indexPath.row].placemark
            locationSelectionClosure?(placemark, false)
        default:
            break
        }
    }
}
