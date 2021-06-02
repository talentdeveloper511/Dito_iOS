//
//  MensaDetailViewController.swift
//  iPaths
//
//  Created by Lebron on 3/30/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import UIKit
import BetterSegmentedControl
import CoreLocation

class MensaDetailViewController: UIViewController{


    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var select: BetterSegmentedControl!
    @IBOutlet weak var signBtn: UIButton!
    @IBOutlet weak var idaView: UIView!
    @IBOutlet weak var idaPickLabel: UILabel!
    @IBOutlet weak var idaDeliverLabel: UILabel!
    @IBOutlet weak var regresoView: UIView!
    @IBOutlet weak var regPickLabel: UILabel!
    @IBOutlet weak var regDelLabel: UILabel!
    @IBOutlet weak var regFinalLabel: UILabel!

    @IBOutlet weak var idaPickLugar: UITextField!
    var apiManager: ApiManager?
    
    @IBOutlet weak var idaDeliLugar: UITextField!
    
    @IBOutlet weak var idaContactName: UITextField!
    
    @IBOutlet weak var idaContactNum: UITextField!
    
    
    @IBOutlet weak var regPickLugar: UITextField!
    
    @IBOutlet weak var regDeliLugar: UITextField!
    
    
    @IBOutlet weak var regFinalLugar: UITextField!
    
    @IBOutlet weak var regContactName: UITextField!
    
    
    @IBOutlet weak var regContactNum: UITextField!
    
    var timeList: [TimeModel] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        select.titles = ["Ida", "Regreso"]
        select.titleFont = UIFont(name: "RimouskiLt", size: 25.0)!
        select.selectedTitleFont = UIFont(name: "RimouskiRg",size: 25.0)!
        titleLabel.font = UIFont(name: "RimouskiRg-Regular2", size: 39.0)!
        signBtn.titleLabel?.font = UIFont(name: "RimouskiRg",size: 20.0)!
        
        idaView.isHidden = false
        regresoView.isHidden = true
        
        
        if((UserDefaults.standard.string(forKey:"pick_reg")) != nil   ){
            
            if(UserDefaults.standard.string(forKey: "pick_reg") == "reg"){
                do {
                    try select.setIndex(1)
                    //all fine with jsonData here
                } catch {
                    //handle error
                    print(error)
                }
            }
      
        }
        

        
        initData()
    
        
    }
    
    @IBAction func backTo(_ sender: Any) {
        let vc = self.parent as! ContainerViewController
        let mensaViewController = self.storyboard?.instantiateViewController(withIdentifier: "MensaViewController") as! MensaViewController
        vc.addChildViewController(mensaViewController)
        vc.containerView.addSubview(mensaViewController.view)
    }
    func initData(){
        self.idaPickLabel.text = UserDefaults.standard.string(forKey: "pickAddr")
        self.idaDeliverLabel.text = UserDefaults.standard.string(forKey: "delAddr")
        
        self.regPickLabel.text = UserDefaults.standard.string(forKey: "pickAddrReg")
        self.regDelLabel.text = UserDefaults.standard.string(forKey: "deliAddrReg")
        self.regFinalLabel.text = UserDefaults.standard.string(forKey: "finalAddrReg")
        
        
        
        if(UserDefaults.standard.string(forKey: "idaPickLugar") != nil){
            self.idaPickLugar.text = UserDefaults.standard.string(forKey: "idaPickLugar")
        }
        if(UserDefaults.standard.string(forKey: "idaDeliLugar") != nil){
            self.idaDeliLugar.text = UserDefaults.standard.string(forKey: "idaDeliLugar")
        }
        if(UserDefaults.standard.string(forKey: "regPickLugar") != nil){
            self.regPickLugar.text = UserDefaults.standard.string(forKey: "regPickLugar")
        }
        if(UserDefaults.standard.string(forKey: "regDeliLugar") != nil){
            self.regDeliLugar.text = UserDefaults.standard.string(forKey: "regDeliLugar")
        }
        if(UserDefaults.standard.string(forKey: "regFinalLugar") != nil){
            self.regFinalLugar.text = UserDefaults.standard.string(forKey: "regFinalLugar")
        }
        

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func selectMensa(_ sender: Any) {
        
        switch select.index {
        case 0:
            titleLabel.text = "Ida"
            idaView.isHidden = false
            regresoView.isHidden = true

            break
        case 1:
            titleLabel.text = "Regreso"
            idaView.isHidden = true
            regresoView.isHidden = false

            break
        default:
            print("testing")
        }
        
    }
    
    
    func formValidation() -> Bool{
        if (select.index == 0){
            if(self.idaPickLugar.text! == "" || self.idaDeliLugar.text! == "" || self.idaContactNum.text! == "" || self.idaContactName.text! == ""){
                return false
            }
            else{
               return true
            }
        }
        
        else{
            if(self.regPickLugar.text! == "" || self.regDeliLugar.text! == "" || self.regFinalLugar.text! == "" || self.regContactNum.text! == "" || self.regContactName.text! == ""){
                return false
            }
            
            else{
                return true
            }
        }
    }
    
    func getPricefromDistance(distance: Double) -> String {

        return ""
    }

  
    @IBAction func sign(_ sender: Any) {

        //calculate the distance using latitude , longtitute
        
        if(formValidation()){
            if(select.index == 0)
            {
                if(idaPickLabel.text != "" || idaDeliverLabel.text != ""){
                    
                    let pick_latitude = (UserDefaults.standard.string(forKey: "order_pick_lat")! as NSString).doubleValue
                    let pick_longtitude = (UserDefaults.standard.string(forKey: "order_pick_long")! as NSString).doubleValue
                    
                    let del_latitude = (UserDefaults.standard.string(forKey: "order_deli_lat")! as NSString).doubleValue
                    let del_longtitude = (UserDefaults.standard.string(forKey: "order_deli_long")! as NSString).doubleValue
                    
                    let pick_location = CLLocation(latitude: pick_latitude, longitude: pick_longtitude)
                    let del_location = CLLocation(latitude: del_latitude, longitude: del_longtitude)
                    let temp_distance = pick_location.distance(from: del_location)
                    let distance = temp_distance/1000
                    
                    var price = ""
                    SVProgressHUD.show(withStatus: "Please wait...")
                    ApiManager.sharedInstance().getTimeList(completion: { (arrClass, strError) in
                        if let strError = strError {
                            SVProgressHUD.showError(withStatus: strError)
                            print("Load Data error")
                        }else{
                            SVProgressHUD.dismiss()
                            if let list = arrClass?.list{
                                self.timeList = list
                            }
                            let date = Date()
                            let calendar = Calendar.current
                            let hour = calendar.component(.hour, from: date)
                            
                            
                            for timeCell in self.timeList{
                                var from_time = timeCell.from_time?.components(separatedBy: ":")
                                var from_time_hour = Int(from_time![0])
                                
                                var from_distance = 0.0
                                var end_distance = 0.0
                                if let fromDistance = timeCell.distance{
                                    from_distance = Double(fromDistance)!
                                    
                                }
                                if let endDistance = timeCell.end_distance{
                                    end_distance = Double(endDistance)!
                                    
                                }
                                
                                
                                if(timeCell.from_time?.range(of:"PM") != nil){
                                    from_time_hour = from_time_hour! + 12
                                }
                                let to_time = timeCell.to_time?.components(separatedBy: ":")
                                var to_time_hour = Int(to_time![0])
                                
                                if(timeCell.to_time?.range(of:"PM") != nil){
                                    to_time_hour = to_time_hour! + 12
                                }
                                
                                
                                if(from_time_hour! > to_time_hour!){
                                    if((hour >= 0 && hour <= to_time_hour!) || (hour <= 24 && hour >= from_time_hour!  ) ){
                                        if(from_distance < distance && distance <= end_distance ){
                                            if let exactPrice = timeCell.price{
                                                price = exactPrice
                                                
                                            }
                                        }
                                    }
                                    
                                }else{
                                    if(hour >= from_time_hour! && hour <= to_time_hour!){
                                        if(from_distance < distance && distance <= end_distance ){
                                            if let exactPrice = timeCell.price{
                                                price = exactPrice
                                                print(price)
                                                
                                            }
                                        }
                                    }
                                }
                            }
                            
                            let tempAmount = (price as NSString).doubleValue
                            
                            let amount: String = String(format: "%.0f", tempAmount)
                            if(amount != ""){
                                let contactName = self.idaContactName.text
                                
                                UserDefaults.standard.set(contactName, forKey: "order_contact_name")
                                let contactNum = self.idaContactNum.text
                                UserDefaults.standard.set(contactNum, forKey: "order_contact_num")
                                
                                let pickLugar = self.idaPickLugar.text
                                let deliLugar = self.idaDeliLugar.text
                                
                                UserDefaults.standard.set(pickLugar, forKey: "order_pick_lugar")
                                UserDefaults.standard.set(deliLugar, forKey: "order_deli_lugar")
                                print(amount)
                                UserDefaults.standard.set(amount, forKey: "order_amount")
                                UserDefaults.standard.set("Ida", forKey: "order_type")
                                let vc = self.parent as! ContainerViewController
                                let checkoutViewController = self.storyboard?.instantiateViewController(withIdentifier: "CheckOutViewController") as! CheckOutViewController
                                vc.addChildViewController(checkoutViewController)
                                vc.containerView.addSubview(checkoutViewController.view)
                            }
                            else{
                                let alert = UIAlertController(title: "Dito", message: "Can't Deliver! Very Long Distance", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                self.present(alert, animated: true)
                            }
                        }
                    })
                    

                  
                }
                else{
                    let alert = UIAlertController(title: "Dito", message: "Can't Deliver, Please your enter your delivery address.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
                
            else{
                if(regPickLabel.text != "" || regDelLabel.text != "" || regFinalLabel.text != ""){
                    
                    let pick_latitude = (UserDefaults.standard.string(forKey: "order_pick_lat")! as NSString).doubleValue
                    let pick_longtitude = (UserDefaults.standard.string(forKey: "order_pick_long")! as NSString).doubleValue
                    
                    let del_latitude = (UserDefaults.standard.string(forKey: "order_deli_lat")! as NSString).doubleValue
                    let del_longtitude = (UserDefaults.standard.string(forKey: "order_deli_long")! as NSString).doubleValue
                    
                    let final_latitude = (UserDefaults.standard.string(forKey: "order_final_lat")! as NSString).doubleValue
                    let final_longtitude = (UserDefaults.standard.string(forKey: "order_final_long")! as NSString).doubleValue
                    
                    let pick_location = CLLocation(latitude: pick_latitude, longitude: pick_longtitude)
                    let del_location = CLLocation(latitude: del_latitude, longitude: del_longtitude)
                    let final_location = CLLocation(latitude: final_latitude, longitude: final_longtitude)
                    let one_distance = pick_location.distance(from: del_location)
                    let sec_distance = del_location.distance(from: final_location)
                    
                    let distance = (one_distance + sec_distance) / 1000
                    
                    let distance1 = one_distance / 1000
                    let distance2 = one_distance / 1000
                    
                    var price1 = ""
                    var price2 = ""
                    SVProgressHUD.show(withStatus: "Please wait...")
                    ApiManager.sharedInstance().getTimeList(completion: { (arrClass, strError) in
                        if let strError = strError {
                            SVProgressHUD.showError(withStatus: strError)
                            print("Load Data error")
                        }else{
                            SVProgressHUD.dismiss()
                            if let list = arrClass?.list{
                                self.timeList = list
                            }
                            let date = Date()
                            let calendar = Calendar.current
                            let hour = calendar.component(.hour, from: date)
                            
                            
                            for timeCell in self.timeList{
                                var from_time = timeCell.from_time?.components(separatedBy: ":")
                                var from_time_hour = Int(from_time![0])
                                
                                var from_distance = 0.0
                                var end_distance = 0.0
                                if let fromDistance = timeCell.distance{
                                    from_distance = Double(fromDistance)!
                                    
                                }
                                if let endDistance = timeCell.end_distance{
                                    end_distance = Double(endDistance)!
                                    
                                }
                                
                                
                                if(timeCell.from_time?.range(of:"PM") != nil){
                                    from_time_hour = from_time_hour! + 12
                                }
                                let to_time = timeCell.to_time?.components(separatedBy: ":")
                                var to_time_hour = Int(to_time![0])
                                
                                if(timeCell.to_time?.range(of:"PM") != nil){
                                    to_time_hour = to_time_hour! + 12
                                }
                                
                                
                                if(from_time_hour! > to_time_hour!){
                                    if((hour >= 0 && hour <= to_time_hour!) || (hour <= 24 && hour >= from_time_hour!  ) ){
                                        if(from_distance < distance1 && distance1 <= end_distance ){
                                            if let exactPrice = timeCell.price{
                                                price1 = exactPrice
                                                
                                            }
    
                                        }
                                        
                                        if(from_distance < distance2 && distance2 <= end_distance ){
                                            if let exactPrice2 = timeCell.price{
                                                price2 = exactPrice2
                                                
                                            }
                                        }
                                    }
                                    
                                }else{
                                    if(hour >= from_time_hour! && hour <= to_time_hour!){
                                        if(from_distance < distance1 && distance1 <= end_distance ){
                                            if let exactPrice = timeCell.price{
                                                price1 = exactPrice
                                                
                                            }
                                            
                                        }
                                        
                                        if(from_distance < distance2 && distance2 <= end_distance ){
                                            if let exactPrice2 = timeCell.price{
                                                price2 = exactPrice2
                                                
                                            }
                                        }
                                    }
                                }
                            }
                            
                            let amount1 = (price1 as NSString).doubleValue
                            let amount2 = (price2 as NSString).doubleValue
                            
                            
                            let tempAmount = amount1 + amount2
                            
                            let amount: String = String(format: "%.0f", tempAmount)
                            
                            if(amount != ""){
                                
                                UserDefaults.standard.set(amount, forKey: "order_amount")
                                UserDefaults.standard.set("Reg", forKey: "order_type")
                                
                                let contactName = self.regContactName.text
                                
                                UserDefaults.standard.set(contactName, forKey: "order_contact_name")
                                let contactNum = self.regContactNum.text
                                UserDefaults.standard.set(contactNum, forKey: "order_contact_num")
                                
                                let pickLugar = self.regPickLugar.text
                                let deliLugar = self.regDeliLugar.text
                                let finalLugar = self.regFinalLugar.text
                                UserDefaults.standard.set(pickLugar, forKey: "order_pick_lugar")
                                UserDefaults.standard.set(deliLugar, forKey: "order_deli_lugar")
                                UserDefaults.standard.set(finalLugar, forKey: "order_final_lugar")
                                
                                let vc = self.parent as! ContainerViewController
                                let checkoutViewController = self.storyboard?.instantiateViewController(withIdentifier: "CheckOutViewController") as! CheckOutViewController
                                vc.addChildViewController(checkoutViewController)
                                vc.containerView.addSubview(checkoutViewController.view)
                            }else{
                                let alert = UIAlertController(title: "Dito", message: "Can't Deliver! Very Long Distance", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                self.present(alert, animated: true)
                            }

                        }
                    })
                    
             
                 
                    
                 
                    
                }
                    
                else{
                    let alert = UIAlertController(title: "Dito", message: "Can't Deliver! Please your enter your delivery address.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }else{
            let alert = UIAlertController(title: "Input Error", message: "Please fill out your forms.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
        
        
        

    }
    
    func saveLugar(){
        
        let temp1 = self.idaPickLugar.text
        let temp2 = self.idaDeliLugar.text
        let temp3 = self.regPickLugar.text
        let temp4 = self.regDeliLugar.text
        let temp5 = self.regFinalLugar.text
        
        UserDefaults.standard.set(temp1, forKey: "idaPickLugar")
        UserDefaults.standard.set(temp2, forKey: "idaDeliLugar")
        UserDefaults.standard.set(temp3, forKey: "regPickLugar")
        UserDefaults.standard.set(temp4, forKey: "regDeliLugar")
        UserDefaults.standard.set(temp5, forKey: "regFinalLugar")
        
        
    }
    
    @IBAction func pickAddress(_ sender: Any) {
        
        
        UserDefaults.standard.set("pickAddress", forKey:"pick_type")
        self.saveLugar()
        let vc = self.parent as! ContainerViewController
        let pickAddressViewController = storyboard?.instantiateViewController(withIdentifier: "PickAddressViewController") as! PickAddressViewController
        vc.addChildViewController(pickAddressViewController)
        vc.containerView.addSubview(pickAddressViewController.view)
        
        
        
        
        
        
        
    }
    @IBAction func deliveryAddr(_ sender: Any) {
        UserDefaults.standard.set("deliAddress", forKey:"pick_type")
        self.saveLugar()
        let vc = self.parent as! ContainerViewController
        let pickAddressViewController = storyboard?.instantiateViewController(withIdentifier: "PickAddressViewController") as! PickAddressViewController
        vc.addChildViewController(pickAddressViewController)
        vc.containerView.addSubview(pickAddressViewController.view)

    }

    @IBAction func pickAddrReg(_ sender: Any) {
                UserDefaults.standard.set("pickAddrReg", forKey:"pick_type")
        self.saveLugar()
        let vc = self.parent as! ContainerViewController
        let pickAddressViewController = storyboard?.instantiateViewController(withIdentifier: "PickAddressViewController") as! PickAddressViewController
        vc.addChildViewController(pickAddressViewController)
        vc.containerView.addSubview(pickAddressViewController.view)
    }
    @IBAction func deliAddrReg(_ sender: Any) {
                UserDefaults.standard.set("deliAddrReg", forKey:"pick_type")
        self.saveLugar()
        let vc = self.parent as! ContainerViewController
        let pickAddressViewController = storyboard?.instantiateViewController(withIdentifier: "PickAddressViewController") as! PickAddressViewController
        vc.addChildViewController(pickAddressViewController)
        vc.containerView.addSubview(pickAddressViewController.view)
    }
    @IBAction func finalDesReg(_ sender: Any) {
        UserDefaults.standard.set("finalDesReg", forKey:"pick_type")
        self.saveLugar()
        let vc = self.parent as! ContainerViewController
        let pickAddressViewController = storyboard?.instantiateViewController(withIdentifier: "PickAddressViewController") as! PickAddressViewController
        vc.addChildViewController(pickAddressViewController)
        vc.containerView.addSubview(pickAddressViewController.view)
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


extension Date
{
    
    func dateAt(hours: Int, minutes: Int) -> Date
    {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        
        //get the month/day/year componentsfor today's date.
        
        
        var date_components = calendar.components(
            [NSCalendar.Unit.year,
             NSCalendar.Unit.month,
             NSCalendar.Unit.day],
            from: self)
        
        //Create an NSDate for the specified time today.
        date_components.hour = hours
        date_components.minute = minutes
        date_components.second = 0
        
        let newDate = calendar.date(from: date_components)!
        return newDate
    }
}


