//
//  MapDetailsViewController.swift
//  iPaths
//
//  Created by Marko Dreher on 11/6/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import UIKit
import Mapbox

// MGLPointAnnotation subclass
class MyCustomPointAnnotation: MGLPointAnnotation {
    var willUseImage: Bool = false
}

class MapDetailsViewController: UIViewController, MGLMapViewDelegate {

    
    @IBOutlet weak var mapView: MGLMapView!

    var pickLat: Double?
    var pickLong: Double?
    var deliLat: Double?
    var deliLong: Double?
    var finalLat: Double?
    var finalLong: Double?
    
    var orderType: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        var centerLat = 0.0
        var centerLong = 0.0
        if(self.orderType == "Conveniencia")
        {
            centerLat = deliLat!
            centerLong = deliLong!
        }else{
            centerLat = pickLat!
            centerLong = pickLong!
        }
    
        mapView.setCenter(CLLocationCoordinate2D(latitude: centerLat, longitude: centerLong), zoomLevel: 16, animated: true)
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        loadPins()
    }
    
    
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)    }
    
    func loadPins(){
        if(self.orderType == "Conveniencia")
        {
            let annotation = MGLPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: self.deliLat!, longitude: self.deliLong!)
//            annotation.title = "Central Park"
//            annotation.subtitle = "The biggest park in New York City!"
            mapView.addAnnotation(annotation)
        }else{
            if(self.orderType == "Ida"){
                let pointA = MGLPointAnnotation()
                let pickPoint = CLLocationCoordinate2D(latitude: self.pickLat!, longitude: self.pickLong!)
                pointA.coordinate = pickPoint
                
                let deliveryPoint = CLLocationCoordinate2D(latitude: self.deliLat!, longitude: self.deliLong!)
                let pointB = MGLPointAnnotation()
                pointB.coordinate = deliveryPoint
                
                let markerPlaces = [pointA, pointB]
                mapView.addAnnotations(markerPlaces)
            }
            
            if(self.orderType == "Reg"){
                let pointA = MGLPointAnnotation()
                let pickPoint = CLLocationCoordinate2D(latitude: self.pickLat!, longitude: self.pickLong!)
                pointA.coordinate = pickPoint

                let pointB = MGLPointAnnotation()
                let deliveryPoint = CLLocationCoordinate2D(latitude: self.deliLat!, longitude: self.deliLong!)
                pointB.coordinate = deliveryPoint

                let pointC = MGLPointAnnotation()
                let finalPoint = CLLocationCoordinate2D(latitude: self.finalLat!, longitude: self.finalLong!)
                pointC.coordinate = finalPoint
                
                
             let markerPlaces = [pointA, pointB, pointC]
                mapView.addAnnotations(markerPlaces)
            }
            if(self.orderType != "Reg" && self.orderType != "Ida"){
                let annotation = MGLPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: self.pickLat!, longitude: self.pickLong!)
                //            annotation.title = "Central Park"
                //            annotation.subtitle = "The biggest park in New York City!"
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        
        return nil
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
