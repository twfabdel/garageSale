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
        mapView.isScrollEnabled = false
        
        let mapTap = UITapGestureRecognizer(target: self, action: #selector(openMapsTap(_:)))
        mapView.addGestureRecognizer(mapTap)
    }
    
    // MARK: - Sharing with UIActivityViewController
    
    func calendarAddCompletion(message: String) {
    //var calendarCompletionHandler: (String)->Void = { message in
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func share(_ sender: UIBarButtonItem) {
        guard let sale = sale else { return }
        let text = "Check out this garage sale!\n" + saleToString(sale: sale)
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: [AddToCalendarActivity(with: sale, completion: calendarAddCompletion)])
        activityVC.popoverPresentationController?.sourceView = view
        activityVC.excludedActivityTypes = [.copyToPasteboard]
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    // MARK: - Map and location
    
    @IBAction func openInMaps(_ sender: Any) {
        let title = "Get directions to " + (sale?.address ?? "sale") + "?"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Open in Apple Maps", style: .default) { action in
            if let latitude = self.sale?.latitude, let longitude = self.sale?.longitude, let name = self.sale?.title {
                let coords = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coords))
                mapItem.name = name
                mapItem.openInMaps(launchOptions: nil)
            }
        })
        /* Google Maps URL functionality from
         * https://stackoverflow.com/questions/43276530/how-to-open-google-maps-app-with-a-dropped-pin-swift
         */
        alert.addAction(UIAlertAction(title: "Open in Google Maps", style: .default) { action in
            if let latitude = self.sale?.latitude, let longitude = self.sale?.longitude {
                if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                    UIApplication.shared.open(URL(string:"comgooglemaps://?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving")!, options: [:], completionHandler: nil)
                } else {
                    print("Can't use comgooglemaps://");
                }
            }
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func openMapsTap(_ sender: UITapGestureRecognizer) {
        if sender.state != .ended {
            return
        }
        openInMaps(sender)
    }
    
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
