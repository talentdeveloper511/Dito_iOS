//
//  PickAddressViewController.swift
//  iPaths
//
//  Created by Lebron on 4/7/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import UIKit
import GoogleMaps
import BetterSegmentedControl
import CoreLocation
import Toast_Swift
import Mapbox
import MapboxGeocoder
import GooglePlaces
import Floaty



class PickAddressViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, GMSAutocompleteViewControllerDelegate, MGLMapViewDelegate, FloatyDelegate {

    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var directionView: UIView!
    @IBOutlet weak var pickSegment: BetterSegmentedControl!
    
    @IBOutlet weak var pickMapView: UIView!
    
    @IBOutlet weak var floaty: Floaty!
    
 
    @IBOutlet weak var mapView: MGLMapView!
    var favorties :[Addr] = []
    
    var cityList:[City] = []
    
    var locationManager:CLLocationManager!
    
    var userLocation:CLLocation!
    
    var centerMapCoordinate:CLLocationCoordinate2D!
    
    var marker:MGLPointAnnotation!
    
    var number:Int = 1
    
    var geocoder: Geocoder!
    var geocodingDataTask: URLSessionDataTask?
    
    
    @IBOutlet weak var pickButton: UIButton!
    var user_latitude: CLLocationDegrees!
    var user_longtitude : CLLocationDegrees!
    
    var addressTemp: String?
    
    
    @IBOutlet weak var searchField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Get Current Location
        pickButton.layer.cornerRadius = pickButton.layer.frame.size.height/2
        
        pickSegment.titles = ["Mapa", "Favoritas"]
        pickSegment.titleFont = UIFont(name: "RimouskiLt", size: 22.0)!
        pickSegment.selectedTitleFont = UIFont(name: "RimouskiRg",size: 22.0)!
    
        
//        pickMap.mapType = .hybrid
        
        loadFavoriteData()
        
        self.directionView.isHidden = true
        self.mapView.isHidden = false
        
        self.determineCurrentLocation()
        MGLAccountManager.accessToken = Constants.MAPBOX_KEY
        
        geocoder = Geocoder(accessToken: Constants.MAPBOX_KEY)
        
        marker = MGLPointAnnotation()

        loadCityList()

    }
    
    func loadCityList(){
        SVProgressHUD.show(withStatus: "Please Wait...")

        ApiManager.sharedInstance().getCityList(completion: {(arrClass, strErr) in
            if let strErr = strErr{
                SVProgressHUD.showError(withStatus: strErr)
            }
            else{
                SVProgressHUD.dismiss()
                if let list = arrClass?.list {
                    self.cityList = list
                    print(list)
                    
                }
            }
        })
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
       
         mapView.setCenter(CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude), zoomLevel: 14, animated: true)
        let user_lat = String(format: "%f", place.coordinate.latitude)
        let user_long = String(format: "%f", place.coordinate.longitude)
        
        self.dismiss(animated: true, completion: nil) // dismiss after select place
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("ERROR AUTO COMPLETE \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil) // when cancel search
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

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userLocation = locations[0] as CLLocation

        mapView.setCenter(CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), zoomLevel: 14, animated: true)
        manager.stopUpdatingLocation()

//        self.user_latitude = Double(userLocation.coordinate.latitude)
//        self.user_longtitude = Double(userLocation.coordinate.longitude)
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longtitude = \(userLocation.coordinate.longitude)")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error\(error)")
    }

    
    func mapView(_ mapView: MGLMapView, regionWillChangeAnimated animated: Bool) {
        geocodingDataTask?.cancel()
    }
    
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        let options = ReverseGeocodeOptions(coordinate: mapView.centerCoordinate)
        
        marker?.coordinate = mapView.centerCoordinate
        
        //mapView.setCenter(CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude), zoomLevel: 14, animated: true)
        //mapView.addAnnotation(marker!)
        
        user_latitude = mapView.centerCoordinate.latitude
        user_longtitude = mapView.centerCoordinate.longitude
        
        geocodingDataTask = geocoder.geocode(options) { [unowned self] (placemarks, attribution, error) in
            if let error = error {
                NSLog("%@", error)
            } else if let placemarks = placemarks, !placemarks.isEmpty {
                print(placemarks[0].qualifiedName)
                self.searchField.text = placemarks[0].qualifiedName
                self.addressTemp = placemarks[0].qualifiedName
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadFavoriteData(){
        SVProgressHUD.show(withStatus: "Please Wait...")
        let user_id = UserDefaults.standard.string(forKey: "user_id")
        print(user_id)
        ApiManager.sharedInstance().getAddrList(user_id: user_id!, completion: {(arrClass, strErr) in
            if let strErr = strErr{
                SVProgressHUD.showError(withStatus: strErr)
            }
            else{
                SVProgressHUD.dismiss()
                if let list = arrClass?.list {
                    self.favorties = list
                    print(list)
                    self.tableView.reloadData()
                    
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "DirectionTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DirectionTableViewCell
        let favorite = favorties[indexPath.row]
        
        cell?.directDes.text = favorite.addr
        cell?.directDes.font = UIFont(name: "RimouskiSb-Regular", size: 20)
        cell?.directTitle.text = favorite.name
        cell?.directTitle.font = UIFont(name: "RimouskiSb-Regular", size: 31)
        cell?.directImage.image = UIImage(named:"picklogo")
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorties[indexPath.row]
        
        
        let product_order = UserDefaults.standard.string(forKey: "product_order")
        let user_lat = favorite.latitude
        let user_long = favorite.longtitude
        let addr = favorite.addr
        //        self.view.window?.makeToast(self.getAddressForLatLng(latitude: user_lat, longitude: user_long))
        
        if(product_order == "messenger_order"){
            let messenger_type = UserDefaults.standard.string(forKey: "messenger_service")
            if(messenger_type == "Bank")
            {
                UserDefaults.standard.set(user_long, forKey:"order_pick_long")
                UserDefaults.standard.set(user_lat, forKey:"order_pick_lat" )
                UserDefaults.standard.set( addr, forKey: "order_pick_addr")
                let amount = UserDefaults.standard.string(forKey: "amount")
                UserDefaults.standard.set( amount, forKey:"order_amount")
                getHomeContactNum()

            }
            if(messenger_type == "Service"){
                UserDefaults.standard.set(user_long, forKey:"order_pick_long")
                UserDefaults.standard.set(user_lat, forKey:"order_pick_lat" )
                
                UserDefaults.standard.set( addr, forKey: "order_pick_addr")

                let amount = UserDefaults.standard.string(forKey: "amount")
                UserDefaults.standard.set( amount, forKey:"order_amount")
                getHomeContactNum()
                
            }
            if(messenger_type == "Messenger"){
                
                let pick_type = UserDefaults.standard.string(forKey: "pick_type")
                
                switch pick_type{
                case "pickAddress":
                    UserDefaults.standard.set(user_long, forKey:"order_pick_long")
                    UserDefaults.standard.set(user_lat, forKey:"order_pick_lat" )
                    UserDefaults.standard.set(addr, forKey: "pickAddr")
                    UserDefaults.standard.set("", forKey:"pick_reg")
                    
                    break
                case "deliAddress":
                    UserDefaults.standard.set(user_long, forKey:"order_deli_long")
                    UserDefaults.standard.set(user_lat, forKey:"order_deli_lat" )
                    UserDefaults.standard.set(addr, forKey: "delAddr")
                    UserDefaults.standard.set("", forKey:"pick_reg")
                    break
                case "pickAddrReg":
                    UserDefaults.standard.set(user_long, forKey:"order_pick_long")
                    UserDefaults.standard.set(user_lat, forKey:"order_pick_lat" )
                    UserDefaults.standard.set(addr, forKey: "pickAddrReg")
                    UserDefaults.standard.set("reg", forKey:"pick_reg")
                    break
                case "deliAddrReg":
                    UserDefaults.standard.set(user_long, forKey:"order_deli_long")
                    UserDefaults.standard.set(user_lat, forKey:"order_deli_lat")
                    UserDefaults.standard.set(addr, forKey: "deliAddrReg")
                    UserDefaults.standard.set("reg", forKey:"pick_reg")
                    break
                case "finalDesReg":
                    UserDefaults.standard.set(user_long, forKey:"order_final_long")
                    UserDefaults.standard.set(user_lat, forKey:"order_final_lat" )
                    UserDefaults.standard.set(addr, forKey: "finalAddrReg")
                    UserDefaults.standard.set("reg", forKey:"pick_reg")
                    break
                default:
                    break
                }
                
                let vc = self.parent as! ContainerViewController
                let mensaDtailViewController = storyboard?.instantiateViewController(withIdentifier: "MensaDetailViewController") as! MensaDetailViewController
                vc.addChildViewController(mensaDtailViewController)
                vc.containerView.addSubview(mensaDtailViewController.view)
            }
        }
            
        else{
            
            UserDefaults.standard.set(user_long, forKey:"order_deli_long")
            UserDefaults.standard.set(user_lat, forKey:"order_deli_lat" )
            UserDefaults.standard.set( addr, forKey: "delAddr")
            
            
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Message", message: "Enter your Contact info", preferredStyle: .alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (number_tf) in
                number_tf.placeholder = "Home or Business No"
            }
            alert.addTextField { (contact_tf) in
                contact_tf.placeholder = "Phone Number"
            }
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let number_text = alert?.textFields![0] as! UITextField
                let phone_text = alert?.textFields![1] as! UITextField
                
                UserDefaults.standard.set(number_text.text, forKey: "order_contact_name")
                UserDefaults.standard.set(phone_text.text, forKey: "order_contact_num")
                
                // 4. Present the alert.
                
                
                let vc = self.parent as! ContainerViewController
                let contentViewController = self.storyboard?.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
                vc.addChildViewController(contentViewController)
                vc.containerView.addSubview(contentViewController.view)
                
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
                alert?.dismiss(animated: false, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    func getHomeContactNum() {
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Message", message: "Enter your Contact info", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (number_tf) in
            number_tf.placeholder = "Home or Business No"
        }
        alert.addTextField { (contact_tf) in
            contact_tf.placeholder = "Phone Number"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let number_text = alert?.textFields![0] as! UITextField
            let phone_text = alert?.textFields![1] as! UITextField
            
            UserDefaults.standard.set(number_text.text, forKey: "order_contact_name")
            UserDefaults.standard.set(phone_text.text, forKey: "order_contact_num")
            
            // 4. Present the alert.
            
            
            let vc = self.parent as! ContainerViewController
            let checkOutViewController = self.storyboard?.instantiateViewController(withIdentifier: "CheckOutViewController") as! CheckOutViewController
            vc.addChildViewController(checkOutViewController)
            vc.containerView.addSubview(checkOutViewController.view)
            
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
            alert?.dismiss(animated: false, completion: nil)
            
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func selectPick(_ sender: Any) {
        
        switch pickSegment.index {
        case 0:
            self.directionView.isHidden = true
            self.pickMapView.isHidden = false
            
            break;
        case 1:
            self.directionView.isHidden = false
            self.pickMapView.isHidden = true
            break;

        default:
            break;
        }
        
    }
    
    func getAddressFromLocatLon(pdblLatitude: String, withLongitude pdblLongitude: String){
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
//                    print(pm.country)
//                    print(pm.locality)
//                    print(pm.subLocality)
//                    print(pm.thoroughfare)
//                    print(pm.postalCode)
//                    print(pm.subThoroughfare)
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    print(addressString)
                    self.addressTemp = addressString
                }
        })
        
    }
    
    func getAddressForLatLng(latitude: String, longitude: String) -> String {
        
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=\(Constants.GOOGLE_PLACE_API)")
        print(url)
        
        let data = NSData(contentsOf: url as! URL)
        
        if data != nil {
            let json = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            if let result = json["results"] as? NSArray   {
                print(result)
                if result.count > 0 {
                    if let addresss:NSDictionary = result[0] as! NSDictionary {
                        if let address = addresss["address_components"] as? NSArray {
                            var newaddress = ""
                            var number = ""
                            var street = ""
                            var city = ""
                            var state = ""
                            var zip = ""
                            
                            if(address.count > 1) {
                                number =  (address.object(at: 0) as! NSDictionary)["short_name"] as! String
                            }
                            if(address.count > 2) {
                                street = (address.object(at: 1) as! NSDictionary)["short_name"] as! String
                            }
                            if(address.count > 3) {
                                city = (address.object(at: 2) as! NSDictionary)["long_name"] as! String
                            }
                            if(address.count > 4) {
                                state = (address.object(at: 4) as! NSDictionary)["short_name"] as! String
                            }
                            if(address.count > 6) {
                                zip =  (address.object(at: 6) as! NSDictionary)["short_name"] as! String
                            }
                            newaddress = "\(number) \(street), \(city), \(state) \(zip)"
                            
                            print(newaddress)
                            return newaddress
                        }
                        else {
                            return ""
                        }
                    }
                } else {
                    return ""
                }
            }
            else {
                return ""
            }
            
        }   else {
            return ""
        }
        
    }
    
    
    func getCurrentTime() ->String {
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        
        let today_string = String(year!) + "-" + String(month!) + "-" + String(day!) + " " + String(hour!)  + ":" + String(minute!) + ":" +  String(second!)
        print(today_string)
        return today_string
    }
    
    
    
    
    func validatePoint(address: String) -> Int {
        var i = 0
        print(address)
        if(address.count < 2){
            return 2
        }
        for city in cityList{

//            if (!(address.range(of: (city.city_name!))?.isEmpty)!) {
//                print(address.range(of: (city.city_name!)))
//                if address.range(of:"HN") != nil {
//                        i += 1
//                }
//            }
//            else{
//                if (address.range(of: "TGU") != nil){
//                    i += 1
//                }
//            }

            
            if let cityName = city.city_name{
                
                if(address.range(of: cityName) == nil){
                    if (address.range(of: "TGU") == nil){
                        i += 1
                    }
                    print(cityName)
                    
                }
                else{
                    return 1
                    
                }
            }
        }
        print(i)
        
        if(i > 0){
            return 0
        }
        else{
            return 1
        }
        
        
    }
    
    @IBAction func useLocation(_ sender: Any) {
        
        let user_lat = String(format: "%f", user_latitude)
        let user_long = String(format: "%f", user_longtitude)
        if let addr = self.addressTemp{
            
            if(self.validatePoint(address: addr) == 1){
                let product_order = UserDefaults.standard.string(forKey: "product_order")
                
                //        self.view.window?.makeToast(self.getAddressForLatLng(latitude: user_lat, longitude: user_long))
                
                if(product_order == "messenger_order"){
                    let messenger_type = UserDefaults.standard.string(forKey: "messenger_service")
                    if(messenger_type == "Bank")
                    {
                        UserDefaults.standard.set(user_long, forKey:"order_pick_long")
                        UserDefaults.standard.set(user_lat, forKey:"order_pick_lat" )
                        
                        UserDefaults.standard.set( addr, forKey: "order_pick_addr")
                        
                        
                        
                        let amount = UserDefaults.standard.string(forKey: "amount")
                        UserDefaults.standard.set( amount, forKey:"order_amount")
                        
                        //1. Create the alert controller.
                        let alert = UIAlertController(title: "Message", message: "Enter your Contact info", preferredStyle: .alert)
                        
                        //2. Add the text field. You can configure it however you need.
                        alert.addTextField { (number_tf) in
                            number_tf.placeholder = "Home or Business No"
                        }
                        alert.addTextField { (contact_tf) in
                            contact_tf.placeholder = "Phone Number"
                        }
                        
                        // 3. Grab the value from the text field, and print it when the user clicks OK.
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                            let number_text = alert?.textFields![0] as! UITextField
                            let phone_text = alert?.textFields![1] as! UITextField
                            
                            UserDefaults.standard.set(number_text.text, forKey: "order_contact_name")
                            UserDefaults.standard.set(phone_text.text, forKey: "order_contact_num")
                            
                            // 4. Present the alert.
                            
                            
                            let vc = self.parent as! ContainerViewController
                            let checkOutViewController = self.storyboard?.instantiateViewController(withIdentifier: "CheckOutViewController") as! CheckOutViewController
                            vc.addChildViewController(checkOutViewController)
                            vc.containerView.addSubview(checkOutViewController.view)
                            
                            
                        }))
                        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
                            alert?.dismiss(animated: false, completion: nil)
                            
                            
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
  
                    }
                    if(messenger_type == "Service"){
                        UserDefaults.standard.set(user_long, forKey:"order_pick_long")
                        UserDefaults.standard.set(user_lat, forKey:"order_pick_lat" )
                        
                        UserDefaults.standard.set( addr, forKey: "order_pick_addr")
                        
                        
                        
                        let amount = UserDefaults.standard.string(forKey: "amount")
                        UserDefaults.standard.set( amount, forKey:"order_amount")
                        //1. Create the alert controller.
                        let alert = UIAlertController(title: "Message", message: "Enter your Contact info", preferredStyle: .alert)
                        
                        //2. Add the text field. You can configure it however you need.
                        alert.addTextField { (number_tf) in
                            number_tf.placeholder = "Home or Business No"
                        }
                        alert.addTextField { (contact_tf) in
                            contact_tf.placeholder = "Phone Number"
                        }
                        
                        // 3. Grab the value from the text field, and print it when the user clicks OK.
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                            let number_text = alert?.textFields![0] as! UITextField
                            let phone_text = alert?.textFields![1] as! UITextField
                            
                            UserDefaults.standard.set(number_text.text, forKey: "order_contact_name")
                            UserDefaults.standard.set(phone_text.text, forKey: "order_contact_num")
                            
                            // 4. Present the alert.
                            
                            
                            let vc = self.parent as! ContainerViewController
                            let checkOutViewController = self.storyboard?.instantiateViewController(withIdentifier: "CheckOutViewController") as! CheckOutViewController
                            vc.addChildViewController(checkOutViewController)
                            vc.containerView.addSubview(checkOutViewController.view)
                            
                            
                        }))
                        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
                            alert?.dismiss(animated: false, completion: nil)
                            
                            
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    if(messenger_type == "Messenger"){
                        
                        let pick_type = UserDefaults.standard.string(forKey: "pick_type")
                        
                        switch pick_type{
                        case "pickAddress":
                            UserDefaults.standard.set(user_long, forKey:"order_pick_long")
                            UserDefaults.standard.set(user_lat, forKey:"order_pick_lat" )
                            UserDefaults.standard.set(addr, forKey: "pickAddr")
                            UserDefaults.standard.set("", forKey:"pick_reg")
                            
                            break
                        case "deliAddress":
                            UserDefaults.standard.set(user_long, forKey:"order_deli_long")
                            UserDefaults.standard.set(user_lat, forKey:"order_deli_lat" )
                            UserDefaults.standard.set(addr, forKey: "delAddr")
                            UserDefaults.standard.set("", forKey:"pick_reg")
                            break
                        case "pickAddrReg":
                            UserDefaults.standard.set(user_long, forKey:"order_pick_long")
                            UserDefaults.standard.set(user_lat, forKey:"order_pick_lat" )
                            UserDefaults.standard.set(addr, forKey: "pickAddrReg")
                            UserDefaults.standard.set("reg", forKey:"pick_reg")
                            break
                        case "deliAddrReg":
                            UserDefaults.standard.set(user_long, forKey:"order_deli_long")
                            UserDefaults.standard.set(user_lat, forKey:"order_deli_lat")
                            UserDefaults.standard.set(addr, forKey: "deliAddrReg")
                            UserDefaults.standard.set("reg", forKey:"pick_reg")
                            break
                            
                        case "finalDesReg":
                            UserDefaults.standard.set(user_long, forKey:"order_final_long")
                            UserDefaults.standard.set(user_lat, forKey:"order_final_lat" )
                            UserDefaults.standard.set(addr, forKey: "finalAddrReg")
                            UserDefaults.standard.set("reg", forKey:"pick_reg")
                            break
                        default:
                            break
                        }
                        
                        let vc = self.parent as! ContainerViewController
                        let mensaDtailViewController = storyboard?.instantiateViewController(withIdentifier: "MensaDetailViewController") as! MensaDetailViewController
                        vc.addChildViewController(mensaDtailViewController)
                        vc.containerView.addSubview(mensaDtailViewController.view)
                    }
                }
                    
                else{
                    
                    UserDefaults.standard.set(user_long, forKey:"order_deli_long")
                    UserDefaults.standard.set(user_lat, forKey:"order_deli_lat" )
                    UserDefaults.standard.set( addr, forKey: "delAddr")
                    
                    //1. Create the alert controller.
                    let alert = UIAlertController(title: "Message", message: "Enter your Contact info", preferredStyle: .alert)
                    
                    //2. Add the text field. You can configure it however you need.
                    alert.addTextField { (number_tf) in
                        number_tf.placeholder = "Home or Business No"
                    }
                    alert.addTextField { (contact_tf) in
                        contact_tf.placeholder = "Phone Number"
                    }
                    
                    // 3. Grab the value from the text field, and print it when the user clicks OK.
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                        let number_text = alert?.textFields![0] as! UITextField
                        let phone_text = alert?.textFields![1] as! UITextField
                        
                        UserDefaults.standard.set(number_text.text, forKey: "order_contact_name")
                        UserDefaults.standard.set(phone_text.text, forKey: "order_contact_num")
                        
                        // 4. Present the alert.
                        
                        
                        let vc = self.parent as! ContainerViewController
                        let contentViewController = self.storyboard?.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
                        vc.addChildViewController(contentViewController)
                        vc.containerView.addSubview(contentViewController.view)
                        
                        
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
                        alert?.dismiss(animated: false, completion: nil)
                        
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }
                
            }
            else{
                if(validatePoint(address: addr) == 2){
                    self.view.makeToast("You have exceeded your daily request quota for this API. If you did not set a custom daily request quota, verify your project has an active billing account: http://g.co/dev/maps-no-account")
                    
                }
                let alertController = UIAlertController(title: "Pick Error", message: "Can't deliver in this area!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Pick again", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }

       

        

    }
    @IBAction func openSearchAddress(_ sender: Any) {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        self.locationManager.startUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    @IBAction func openSearch(_ sender: Any) {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        self.locationManager.startUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    // MARK: - Floaty Delegate Methods
    func floatyWillOpen(_ floaty: Floaty) {
        print("Floaty Will Open")
    }
    
    func floatyDidOpen(_ floaty: Floaty) {
        print("Floaty Did Open")
    }
    
    func floatyWillClose(_ floaty: Floaty) {
        print("Floaty Will Close")
    }
    
    func floatyDidClose(_ floaty: Floaty) {
        print("Floaty Did Close")
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
