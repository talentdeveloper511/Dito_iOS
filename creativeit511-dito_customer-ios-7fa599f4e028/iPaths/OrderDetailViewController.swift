//
//  OrderDetailViewController.swift
//  iPaths
//
//  Created by Marko Dreher on 9/13/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController {

    @IBOutlet weak var acceptedTime: UILabel!
    
    @IBOutlet weak var completeTime: UILabel!
    
    @IBOutlet weak var abText: UILabel!
    @IBOutlet weak var bcText: UILabel!
    
    @IBOutlet weak var driverName: UILabel!
    
    @IBOutlet weak var phoneNumber: UILabel!
    
    @IBOutlet weak var orderType: UILabel!
    
    @IBOutlet weak var titleText: UILabel!
    
    @IBOutlet weak var dotsImage: UIImageView!
    @IBOutlet weak var driverImage: UIImageView!
    @IBOutlet weak var mainVIew: UIView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var secondAddressImage: UIImageView!
    
    
    var pickLat: Double?
    var pickLong: Double?
    var deliLat: Double?
    var deliLong: Double?
    var finalLat: Double?
    var finalLong: Double?
    
    
    var order: OrderDetailModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainVIew.layer.cornerRadius = 16
        backImage.layer.cornerRadius = 16
        

        loadData()
        // Do any additional setup after loading the view.
    }

    func loadData(){
        let order_id = UserDefaults.standard.integer(forKey: "viewdetail")

        if let type = UserDefaults.standard.string(forKey: "detail_type"){
            if(type == "history"){
                titleText.text = "Historia"
            }else{
                titleText.text = "Detalles del pedido"
            }
        }
        if let temp_order_id: String? = "\(order_id)"{
            
            ApiManager.sharedInstance().getOrder(order_id: temp_order_id!, completion: {(arrClass, strError) in
                if let strError = strError{
                    SVProgressHUD.showError(withStatus: strError)
                }
                else{
                    SVProgressHUD.dismiss()
                    if let list = arrClass {
                        self.order = list
                        if(list.picklat != nil){
                            if let lat = list.picklat {
                                self.pickLat = (lat as NSString).doubleValue
                                
                            }
                        }
                        if(list.picklong != nil){
                            if let long = list.picklong {
                                self.pickLong = (long as NSString).doubleValue
                                
                            }
                        }
                        if(list.delilat != nil){
                            if let lat = list.delilat {
                                self.deliLat = (lat as NSString).doubleValue
                                
                            }
                        }
                        if(list.delilong != nil){
                            if let long = list.delilong {
                                self.deliLong = (long as NSString).doubleValue
                                
                            }
                        }
                        if(list.finallat != nil){
                            if let lat = list.finallat {
                                self.finalLat = (lat as NSString).doubleValue
                                
                            }
                        }
                        if(list.finallong != nil){
                            if let long = list.finallong {
                                self.finalLong = (long as NSString).doubleValue
                                
                            }
                        }

                        self.bcText.isHidden = true
                        self.dotsImage.isHidden = true
                        self.secondAddressImage.isHidden = true
                        if(list.pickaddress != nil){
                            self.abText.text = list.pickaddress!
                        }
                        
                        if(arrClass?.type == "Ida" || arrClass?.type == "Regreso"){
                            self.abText.text = (list.pickaddress)! + " to " + (list.deliaddress)!
                        }
                        if(list.type == "Reg"){
                            self.bcText.text = list.deliaddress! + " to " + list.finaladdress!
                            self.bcText.isHidden = false
                            self.dotsImage.isHidden = false
                            self.secondAddressImage.isHidden = false
                        }else{
                            self.bcText.text = ""
                        }
                        if(list.type == "Product_Order"){
                            self.abText.text = "warehouse" + " to " + list.deliaddress!
                        }
                        
                        self.acceptedTime.text = list.starttime!
                        if(list.endtime != nil){
                            self.completeTime.text = list.endtime!
                        }
                        else{
                         self.completeTime.text = ""
                        }
                        
                        if((list.driver_photo?.count)! > 5){
                            self.driverImage.af_setImage(withURL: URL(string: list.driver_photo!)!)
                            
                            
                        }else{
                            self.driverImage.image = UIImage(named: "avatar")
                        }
                        
                        self.driverImage.layer.cornerRadius = self.driverImage.layer.frame.size.height/2
                        self.driverImage.layer.borderColor = UIColor.yellow.cgColor
                        self.driverImage.layer.borderWidth = 1
                        
                        self.driverName.text =  list.driver_name!
                        self.orderType.text = list.type!
                        if(list.type == "Product_Order"){
                            self.orderType.text = "Conveniencia"
                        }
                        self.phoneNumber.text = list.driver_phone
                        
                        if let type = UserDefaults.standard.string(forKey: "detail_type"){
                            if(type == "history"){
                                UserDefaults.standard.set(list.id, forKey: "order_id_receipt")
                            }
                        }
  
                    }
                }
            })
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func viewReceipt(_ sender: Any) {
        if let type = UserDefaults.standard.string(forKey: "detail_type"){
            if(type == "history"){
                let vc = self.parent as! ContainerViewController
                let addCorpCreditViewController = storyboard?.instantiateViewController(withIdentifier: "ReceiptViewController") as! ReceiptViewController
                vc.addChildViewController(addCorpCreditViewController)
                vc.containerView.addSubview(addCorpCreditViewController.view)
            }
        }
    
    }
    
    @IBAction func viewMap(_ sender: Any) {
        
        
        
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MapDetailsViewController") as! MapDetailsViewController
        nextViewController.orderType = self.orderType.text
        nextViewController.pickLat = self.pickLat
        nextViewController.pickLong = self.pickLong
        nextViewController.deliLong = self.deliLong
        nextViewController.deliLat = self.deliLat
        nextViewController.finalLat = self.finalLat
        nextViewController.finalLong = self.finalLong
        
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func closeModal(_ sender: Any) {
       
        if let type = UserDefaults.standard.string(forKey: "detail_type"){
            if(type == "history"){

              
                let vc = self.parent as! ContainerViewController
                let addCorpCreditViewController = storyboard?.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
                vc.addChildViewController(addCorpCreditViewController)
                vc.containerView.addSubview(addCorpCreditViewController.view)
            }else{
                 let vc = self.parent as! ContainerViewController
                let addCorpCreditViewController = storyboard?.instantiateViewController(withIdentifier: "TrackViewController") as! TrackViewController
                vc.addChildViewController(addCorpCreditViewController)
                vc.containerView.addSubview(addCorpCreditViewController.view)
            }
        }
        
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
