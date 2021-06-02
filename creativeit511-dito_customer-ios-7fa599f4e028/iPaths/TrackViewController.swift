//
//  TrackViewController.swift
//  iPaths
//
//  Created by Lebron on 3/28/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import UIKit
import GoogleMaps
import SendBirdSDK
import AlamofireImage

class TrackViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate{

    @IBOutlet weak var trackMap: GMSMapView!
    @IBOutlet weak var time: UILabel!
    var locationManager:CLLocationManager!
    var tracks = [Track]()
    var orders: [OrderDriver] = []
    var locations: [Order] = []
    var timer: Timer?
    var timerStart: Date?
    
    @IBOutlet weak var tableView: UITableView!
    
    func startTimer() {
        self.timerStart = Date()
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:  #selector(TrackViewController.update), userInfo: nil, repeats: true)
    }
    
   
     @objc func update() {
            // Do some time consuming task in this background thread
            // Mobile app will remain to be responsive to user actions
            print("Performing time consuming task in this background thread")
            
            DispatchQueue.main.async {
                // Task consuming task has completed
                // Update UI from this block of code
                let date = Date()
                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: date)
                let minutes = calendar.component(.minute, from: date)
                let second = calendar.component(.second, from: date)
                if(hour > 12){
                    self.time.text = String(hour - 12) + ":" + String(minutes) + ":" + String(second) + " PM"
                    
                    
                    var tempHour = ""
                    var tempMin = ""
                    var tempSec = ""
                    
                    if((hour - 12) < 10){
                        tempHour = "0" + String((hour - 12)) + ":"
                    }else{
                        tempHour = String((hour - 12)) + ":"
                    }
                    
                    if(minutes < 10){
                        tempMin = "0" + String(minutes) + ":"
                    }else{
                        tempMin = String(minutes) + ":"
                    }
                    
                    if(second < 10){
                        tempSec = "0" + String(second) + " PM"
                    }
                    else{
                        tempSec = String(second) + " PM"
                    }
                    self.time.text = tempHour + tempMin + tempSec
                    
                    
                    
                }else{
                    var tempHour = ""
                    var tempMin = ""
                    var tempSec = ""
                    
                    if(hour < 10){
                        tempHour = "0" + String(hour) + ":"
                    }else{
                        tempHour = String(hour) + ":"
                    }
                    
                    if(minutes < 10){
                        tempMin = "0" + String(minutes) + ":"
                    }else{
                        tempMin = String(minutes) + ":"
                    }
                    
                    if(second < 10){
                        tempSec = "0" + String(second) + " AM"
                    }
                    else{
                        tempSec = String(second) + " AM"
                    }
                    self.time.text = tempHour + tempMin + tempSec

                }
                self.loadOrderData()
                print("Time consuming task has completed. From here we are allowed to update user interface.")
            }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show(withStatus: "Please Wait...")
        self.determineCurrentLocation()

        //loadTrackData();
        displayPins()
        // Do any additional setup after loading the view.
        trackMap.isMyLocationEnabled = true
         trackMap.settings.myLocationButton = true
        SVProgressHUD.dismiss()
        
        startTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.determineCurrentLocation()
//       self.startTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        finishTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        finishTimer()
    }
    
    
    func finishTimer(){
        timer?.invalidate()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "DriverCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DriverTableViewCell
        let order = orders[indexPath.row]
        
        if(order.driver_photo != nil && (order.driver_photo?.count)! > 5){
             cell?.driverImage.af_setImage(withURL: URL(string: order.driver_photo!)!)
        }else{
         cell?.driverImage.image = UIImage(named: "avatar")
        }
        
        cell?.driverImage.layer.cornerRadius = ((cell?.driverImage.frame.size.height)!/2)
        cell?.driverImage.layer.borderColor = UIColor.yellow.cgColor
        cell?.driverImage.layer.borderWidth = 1
        
        cell?.driverName.text = "Nombre: " + order.driver_name!
        cell?.driverTime.text = "Telefono: " + order.driver_phone!
        cell?.driverAmont.text = "Conductor: TGU-" + order.driver!
        cell?.driverPlateNumber.text = "Número de placa: " + order.plateNumber!
        
        if let invoiceNumber = UserDefaults.standard.string(forKey: "invoice_num"){
            if(invoiceNumber != nil){
                cell?.invoiceNumber.text = "Factura: " + invoiceNumber
            }
        }
        if let order_id:Int? = Int(order.id!){
            cell?.viewDetails.tag = 50 + order_id!
        }
        
        cell?.viewDetails.addTarget(self, action: #selector(TrackViewController.setViewDetails(_:)), for: .valueChanged)
        cell?.driverAmont.font = UIFont(name: "RimouskiRg", size: 19)
        cell?.driverName.font = UIFont(name: "RimouskiRg", size: 19)
        cell?.driverTime.font = UIFont(name: "RimouskiRg", size: 19)
        cell?.driverPlateNumber.font = UIFont(name: "RimouskiRg", size: 19)
        
        return cell!
    }
    
    @objc func setViewDetails(_ sender: Any?){
        if let temp = sender as? UISwitch{
            let order_id = temp.tag - 50
            if(temp.isOn){
                UserDefaults.standard.set(order_id, forKey: "viewdetail")
                UserDefaults.standard.set("trackview", forKey: "detail_type")
                let vc = self.parent as! ContainerViewController
                let orderDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailViewController") as! OrderDetailViewController
                vc.addChildViewController(orderDetailVC)
                vc.containerView.addSubview(orderDetailVC.view)
                
                   
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let vc = self.parent as! ContainerViewController
        let email = self.orders[indexPath.row].driver_email
        self.startTimer()
        if((self.orders[indexPath.row].driver_photo?.count)! > 5){
            UserDefaults.standard.set(self.orders[indexPath.row].driver_photo,forKey: "driver_photo")
        }
        else{
            UserDefaults.standard.set("name",forKey: "driver_photo")
        }
        
        print(self.orders[indexPath.row].driver_photo)
        if let name = self.orders[indexPath.row].driver_name{
            UserDefaults.standard.set(name,forKey: "driver_name")
        }
        SBDGroupChannel.createChannel(withUserIds: [email!], isDistinct: true){
            (channel, error) in
            if error != nil {
                print(error?.domain)
                return
            }
            DispatchQueue.main.async {
//                let chatVC = GroupChannelChattingViewController(nibName: "GroupChannelChattingViewController", bundle: Bundle.main)
//                chatVC.groupChannel = channel
//                vc.addChildViewController(chatVC)
//                vc.containerView.addSubview(chatVC.view)
                
                 let chatVC = GroupChannelChattingViewController(nibName: "GroupChannelChattingViewController", bundle: Bundle.main)
                    chatVC.groupChannel = channel
                    self.present(chatVC, animated: true, completion: nil)
            }
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0] as CLLocation
        let camera = GMSCameraPosition.camera(withLatitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude, zoom: 15.0)
        
        
        trackMap.camera = camera
        
        
        manager.stopUpdatingLocation()
        
        //        self.user_latitude = Double(userLocation.coordinate.latitude)
        //        self.user_longtitude = Double(userLocation.coordinate.longitude)
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longtitude = \(userLocation.coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error\(error)")
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
    
    func loadOrderData(){
//        SVProgressHUD.show(withStatus: "Please Wait...")
        let user_id = UserDefaults.standard.string(forKey: "user_id")
        ApiManager.sharedInstance().getActiveOrder(user_id: user_id!, completion: {(arrClass, strError) in
            if let strError = strError{
                //SVProgressHUD.showError(withStatus: strError)
                print("error")
                
            }
            else{
                SVProgressHUD.dismiss()
                if let list = arrClass?.list {
                    self.orders = list
                    print(list)
                    self.displayOrders()
                    self.tableView.reloadData()
                    
                    
                }
            }
        })
    }
    
    
    func displayOrders() {
        
        for order in orders
        {
            print(order.type)
            if let type = order.type {
                switch type {
                case "Ida":
                    let pick_postion: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (order.picklat! as NSString).doubleValue, longitude: (order.picklong! as NSString).doubleValue)
                    let deli_postion: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (order.delilat! as NSString).doubleValue, longitude: (order.delilong! as NSString).doubleValue)
                    showPostion(position: pick_postion, title: "Ida Service", snippet: "Pick Address")
                    showPostion(position: deli_postion, title: "Ida Service", snippet: "Delivery Address")
                    break
                case "Reg":
                    let pick_postion: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (order.picklat! as NSString).doubleValue, longitude: (order.picklong! as NSString).doubleValue)
                    let deli_postion: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (order.delilat! as NSString).doubleValue, longitude: (order.delilong! as NSString).doubleValue)
                    let final_postion: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (order.finallat! as NSString).doubleValue, longitude: (order.finallong! as NSString).doubleValue)
                    showPostion(position: pick_postion, title: "Regreso Service", snippet: "Pick Address")
                    showPostion(position: deli_postion, title: "Regreso Service", snippet: "Delivery Address")
                    showPostion(position: final_postion, title: "Regreso Service", snippet: "Final Address")
                    break
                case "Product_Order":
                    let deli_postion: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (order.delilat! as NSString).doubleValue, longitude: (order.delilong! as NSString).doubleValue)
                    showPostion(position: deli_postion, title: "Alcohol Service", snippet: "Delivery Address")
                    break
                default:
                    let picklat = (order.picklat! as NSString).doubleValue
                    let picklong = (order.picklong! as NSString).doubleValue
                    print(picklong)
                    let pick_postion: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: picklat, longitude: picklong)
                    showPostion(position: pick_postion, title:order.type!, snippet: "Pick Address")
                    break
                }
            }
            if((order.status?.count)! > 5){
                let driverLat = (order.latitude! as NSString).doubleValue
                let driverLong = (order.longitude! as NSString).doubleValue
                let driverPosition: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: driverLat, longitude: driverLong)
                showPostion(position: driverPosition, title: "Driver", snippet: order.driver_name!)

            }
        }
        
    }
    
    func displayPins(){
        let user_id = UserDefaults.standard.string(forKey: "user_id")
        ApiManager.sharedInstance().getOrderLocations(user_id: user_id!, completion: {(arrClass, strError) in
            if let strError = strError{
                //SVProgressHUD.showError(withStatus: strError)
               
                print("error")
                
            }
            else{
                SVProgressHUD.dismiss()
                if let list = arrClass?.list {
                        self.locations = list
                     print(user_id)
                    print(list)
                    for order in self.locations
                    {
                       
                        if let type = order.type {
                            switch type {
                            case "Ida":
                                let pick_postion: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (order.picklat! as NSString).doubleValue, longitude: (order.picklong! as NSString).doubleValue)
                                let deli_postion: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (order.delilat! as NSString).doubleValue, longitude: (order.delilong! as NSString).doubleValue)
                                self.showPostion(position: pick_postion, title: "Ida Service", snippet: "Pick Address")
                                self.showPostion(position: deli_postion, title: "Ida Service", snippet: "Delivery Address")
                                break
                            case "Reg":
                                let pick_postion: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (order.picklat! as NSString).doubleValue, longitude: (order.picklong! as NSString).doubleValue)
                                let deli_postion: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (order.delilat! as NSString).doubleValue, longitude: (order.delilong! as NSString).doubleValue)
                                let final_postion: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (order.finallat! as NSString).doubleValue, longitude: (order.finallong! as NSString).doubleValue)
                                self.showPostion(position: pick_postion, title: "Regreso Service", snippet: "Pick Address")
                                self.showPostion(position: deli_postion, title: "Regreso Service", snippet: "Delivery Address")
                                self.showPostion(position: final_postion, title: "Regreso Service", snippet: "Final Address")
                                break
                            case "Product_Order":
                                let deli_postion: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (order.delilat! as NSString).doubleValue, longitude: (order.delilong! as NSString).doubleValue)
                                self.showPostion(position: deli_postion, title: "Alcohol Service", snippet: "Delivery Address")
                                break
                            default:
                                let picklat = (order.picklat! as NSString).doubleValue
                                let picklong = (order.picklong! as NSString).doubleValue
                                print(picklong)
                                let pick_postion: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: picklat, longitude: picklong)
                                self.showPostion(position: pick_postion, title:order.type!, snippet: "Pick Address")
                                break
                            }
                        }
                    }
                    
                }
            }
        })
    }
    
    func showPostion(position: CLLocationCoordinate2D, title: String, snippet: String){
        let marker = GMSMarker(position: position)
        marker.title = title
        marker.snippet = snippet
        
        marker.icon = UIImage(named: "other_pin")
        
        if(title == "Ida Service"){
             marker.icon = UIImage(named: "picker")
        }
        if(title == "Regreso Service"){
            marker.icon = UIImage(named: "delivery")
        }
        if(title == "Alcohol Service"){
            marker.icon = UIImage(named: "pin")
        }
        
        if(title == "Driver"){
            marker.icon = UIImage(named: "driver_marker")
        }

        marker.map = trackMap
    }
    
    
    func showMarker(position: CLLocationCoordinate2D){
        let marker = GMSMarker()
        marker.position = position
        marker.title = "Palo Alto"
        marker.snippet = "San Francisco"
        marker.map = trackMap
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadTrackData(){
        let track = Track(driverImage: #imageLiteral(resourceName: "driver"), driverName: "Driver: ETA", time: "Desmond 12mins", amount: "XVVI L123.45")
        tracks = [track]
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

