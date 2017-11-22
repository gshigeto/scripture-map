//
//  MapViewController.swift
//  Scripture Map
//
//  Created by Gavin Nitta on 11/9/17.
//  Copyright © 2017 Gavin Nitta. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView?
    
    // MARK: - Actions
    @IBAction func setMapRegion(_ sender: Any) {
        let region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(40.2, -111.65),
                                            MKCoordinateSpanMake(0.1, 0.1))
        mapView?.setRegion(region, animated: true)
    }
    
    // MARK: - Variables
    var locations: [(GeoPlace, GeoTag)] = []
    var centerLocation: GeoPlace? = nil
    
    func reloadPins() {
        if let view = mapView {
            view.removeAnnotations(view.annotations)
            for location in locations {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2DMake(location.0.latitude, location.0.longitude)
                annotation.title = location.0.placename
                mapView?.addAnnotation(annotation)
            }
            if view.annotations.count > 0 {
                view.showAnnotations(view.annotations, animated: true)
            } else {
                view.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2DMake(0, 0), span: MKCoordinateSpanMake(180, 360)), animated: true)
            }
        }
    }
    
    //MARK: - Helpers
    func centerPin(_ place: GeoPlace) {
        mapView?.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2DMake(place.latitude, place.longitude), span: MKCoordinateSpanMake(2.5, 2.5)), animated: true)
    }
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadPins()
        if let geo = centerLocation {
            centerPin(geo)
        }
    }
    
    // MARK: - Map View Delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "Pin"
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if view == nil {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            pinView.canShowCallout = true
            pinView.animatesDrop = true
            pinView.pinTintColor = UIColor.purple
            
            view = pinView
        } else {
            view?.annotation = annotation
        }
        
        return view
    }
}
