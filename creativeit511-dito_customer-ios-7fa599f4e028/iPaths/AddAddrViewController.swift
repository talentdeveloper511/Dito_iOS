//
//  AddAddrViewController.swift
//  iPaths
//
//  Created by Jackson on 5/22/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import Mapbox
import MapboxGeocoder

class AddAddrViewController: UIViewController, CLLocationManagerDelegate, MGLMapViewDelegate,  GMSAutocompleteViewControllerDelegate  {
    


    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var addrName: UITextField!
    @IBOutlet weak var searchField: UITextField!
    var user_latitude: CLLocationDegrees!
    var user_longtitude : CLLocationDegrees!
    var locationManager:CLLocationManager!
    var centerMapCoordinate:CLLocationCoordinate2D!
    
    var userLocation:CLLocation!
    
    var marker:MGLPointAnnotation!
    var geocoder: Geocoder!
    var geocodingDataTask: URLSessionDataTask?
    
    
    var tempAddress: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.addBtn.layer.cornerRadius = addBtn.layer.frame.size.height/2

    
        self.determineCurrentLocation()
        
        MGLAccountManager.accessToken = Constants.MAPBOX_KEY
        
        geocoder = Geocoder(accessToken: Constants.MAPBOX_KEY)
        
        marker = MGLPointAnnotation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func useLocation(_ sender: Any) {
     
        let user_lat = String(format: "%f", self.user_latitude)
        let user_long = String(format: "%f", self.user_longtitude)
        let addr = self.tempAddress
        let name = self.addrName.text
        let user_id = UserDefaults.standard.string(forKey: "user_id")
        if((name?.count)! < 1){
            let alertController = UIAlertController(title: "Warning", message: "Please enter your address name.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            ApiManager.sharedInstance().addFavAddr(Address: addr, longtitude: user_long , latitude: user_lat, name: name! ,user_id: user_id!, completion: {(arrClass, strErr) in
                if let strErr = strErr{
                    SVProgressHUD.showError(withStatus: strErr)
                }
                else{
                    SVProgressHUD.dismiss()
                    let vc = self.parent as! ContainerViewController
                    let favorViewController = self.storyboard?.instantiateViewController(withIdentifier: "FavorViewController") as! FavorViewController
                    vc.addChildViewController(favorViewController)
                    vc.containerView.addSubview(favorViewController.view)
                    
                }
            })
        }
    }
    
    @IBAction func searchAddr(_ sender: Any) {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        self.locationManager.startUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userLocation = locations[0] as CLLocation
        mapView.setCenter(CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), zoomLevel: 14, animated: true)
        manager.stopUpdatingLocation()
        
        //        self.user_latitude = Double(userLocation.coordinate.latitude)
        //        self.user_longtitude = Double(userLocation.coordinate.longitude)
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longtitude = \(userLocation.coordinate.longitude)")
    }
    
    func determineCurrentLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if(CLLocationManager.locationServicesEnabled()){
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error\(error)")
    }
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
         mapView.setCenter(CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude), zoomLevel: 14, animated: true)
        
        let user_lat = String(format: "%f", place.coordinate.latitude)
        let user_long = String(format: "%f", place.coordinate.longitude)
        
//        searchField.text = tempAddress
        
        self.dismiss(animated: true, completion: nil) // dismiss after select place
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("ERROR AUTO COMPLETE \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil) // when cancel search
    }
    
    func mapView(_ mapView: MGLMapView, regionWillChangeAnimated animated: Bool) {
        geocodingDataTask?.cancel()
    }
    
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        let options = ReverseGeocodeOptions(coordinate: mapView.centerCoordinate)
        
        marker?.coordinate = mapView.centerCoordinate
        
        //        mapView.setCenter(CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude), zoomLevel: 14, animated: true)
        mapView.addAnnotation(marker!)
        
        user_latitude = mapView.centerCoordinate.latitude
        user_longtitude = mapView.centerCoordinate.longitude
        
        geocodingDataTask = geocoder.geocode(options) { [unowned self] (placemarks, attribution, error) in
            if let error = error {
                NSLog("%@", error)
            } else if let placemarks = placemarks, !placemarks.isEmpty {
                self.searchField.text = placemarks[0].qualifiedName
                self.tempAddress = placemarks[0].qualifiedName!
            } else {
                self.searchField.text = "No results"
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
