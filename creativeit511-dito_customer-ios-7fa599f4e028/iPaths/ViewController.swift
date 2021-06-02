//
//  ViewController.swift
//  iPaths
//
//  Created by Marko Dreher on 9/26/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import UIKit
import CoreLocation
import Mapbox
import MapboxGeocoder

import MapKit

let MapboxAccessToken = Constants.MAPBOX_KEY

class ViewController: UIViewController, MGLMapViewDelegate {

    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var resultsLabel: UILabel!
    

    
    var geocoder: Geocoder!
    var geocodingDataTask: URLSessionDataTask?
    var marker: MGLPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        MGLAccountManager.accessToken = MapboxAccessToken
        
        geocoder = Geocoder(accessToken: MapboxAccessToken)
        
        marker = MGLPointAnnotation()
        
        
        
    }

    func mapView(_ mapView: MGLMapView, regionWillChangeAnimated animated: Bool) {
        geocodingDataTask?.cancel()
    }
    
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        let options = ReverseGeocodeOptions(coordinate: mapView.centerCoordinate)
        
        marker?.coordinate = mapView.centerCoordinate
        marker?.title = "Test"
        marker?.subtitle = "Test"
        mapView.addAnnotation(marker!)
        
        geocodingDataTask = geocoder.geocode(options) { [unowned self] (placemarks, attribution, error) in
            if let error = error {
                NSLog("%@", error)
            } else if let placemarks = placemarks, !placemarks.isEmpty {
                self.resultsLabel.text = placemarks[0].qualifiedName
            } else {
                self.resultsLabel.text = "No results"
            }
        }
        
    }
    
    // Use the default marker. See also: our view annotation or custom marker examples.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "marker")
        
        if annotationImage == nil {
            // Leaning Tower of Pisa by Stefan Spieler from the Noun Project.
            var image = UIImage(named: "marker1")!
            
            // The anchor point of an annotation is currently always the center. To
            // shift the anchor point to the bottom of the annotation, the image
            // asset includes transparent bottom padding equal to the original image
            // height.
            //
            // To make this padding non-interactive, we create another image object
            // with a custom alignment rect that excludes the padding.
            image = image.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: image.size.height/2, right: 0))
            
            // Initialize the ‘pisa’ annotation image with the UIImage we just loaded.
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "marker")
        }
        
        return annotationImage
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


