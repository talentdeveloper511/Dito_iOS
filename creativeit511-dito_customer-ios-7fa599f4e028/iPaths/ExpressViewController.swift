//
//  ExpressViewController.swift
//  iPaths
//
//  Created by Jackson on 5/8/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import UIKit
import BetterSegmentedControl
import AlamofireImage

class ExpressViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var bancosTitle: UILabel!
    
    @IBOutlet weak var serviceSegment: BetterSegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    var service: String?
    
    var bankList:[BankModel] = []
    var serviceList:[ServiceModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        serviceSegment.titles = ["Bancos", "Servicios" ]
        serviceSegment.titleFont = UIFont(name: "RimouskiLt", size:20.0)!
        serviceSegment.selectedTitleFont = UIFont(name: "RimouskiRg", size: 20.0)!
        bancosTitle.font = UIFont(name: "RimouskiRg-Regular2", size: 39)!
        self.service = UserDefaults.standard.string(forKey: "messenger_service")!
            if(self.service == "Service"){
                do {
                    try serviceSegment.setIndex(1)
                    self.bancosTitle.text = "Pagos"
                    //all fine with jsonData here
                    loadServiceData()
                } catch {
                    //handle error
                    print(error)
                }
            }
        
       
     
        self.loadData()
        loadServiceData()

        // Do any additional setup after loading the view.
    }
    @IBAction func backTo(_ sender: Any) {
        let vc = self.parent as! ContainerViewController
        let mensaViewController = storyboard?.instantiateViewController(withIdentifier: "MensaViewController") as! MensaViewController
        vc.addChildViewController(mensaViewController)
        vc.containerView.addSubview(mensaViewController.view)
   
    }
    
    @IBAction func changeService(_ sender: Any) {
        if(serviceSegment.index == 0)
        {
            self.service = "Bank"
            self.bancosTitle.text = "Bancos"
            UserDefaults.standard.set("Bank", forKey:"messenger_service")
            self.tableView.reloadData()
        }
        else{
            self.service = "Service"
            self.bancosTitle.text = "Pagos"
            UserDefaults.standard.set("Service", forKey:"messenger_service")
            self.tableView.reloadData()
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(self.service == "Bank"){
            return bankList.count
        }
        else{
            return serviceList.count
        }
        
    }



    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BancosTableViewCell") as! BancosTableViewCell
        if(self.service == "Bank"){

            let bank = self.bankList[indexPath.row]

            if(!(bank.photo?.isEmpty)!) {
                cell.bancosImage.af_setImage(withURL: URL(string: bank.photo!)!)
            }
        }
        else{

            let service = self.serviceList[indexPath.row]

            if(!(service.photo?.isEmpty)!) {
                cell.bancosImage.af_setImage(withURL: URL(string: service.photo!)!)
            }
        }
    
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(self.service == "Bank"){
            let bank = bankList[indexPath.row]
            UserDefaults.standard.set("Bank", forKey:"messenger_service")
            if(bank.price?.range(of: ".") != nil){
            UserDefaults.standard.set(bank.price?.components(separatedBy: ".")[0], forKey:"amount")
            }else{
                UserDefaults.standard.set(bank.price, forKey:"amount")
            }
            
            UserDefaults.standard.set(bank.name, forKey:"order_type")
            

        }
        else{
            let service = serviceList[indexPath.row]
            UserDefaults.standard.set("Service", forKey:"messenger_service")
            if(service.price?.range(of: ".") != nil){
                UserDefaults.standard.set(service.price?.components(separatedBy: ".")[0], forKey:"amount")
            }else{
                UserDefaults.standard.set(service.price, forKey:"amount")
            }
             UserDefaults.standard.set(service.name, forKey:"order_type")
            
        }
        let vc = self.parent as! ContainerViewController
        let pickAddressViewController = storyboard?.instantiateViewController(withIdentifier: "PickAddressViewController") as! PickAddressViewController
        vc.addChildViewController(pickAddressViewController)
        vc.containerView.addSubview(pickAddressViewController.view)
        
    }
    func loadData(){
        
    
            SVProgressHUD.show(withStatus: "Please wait...")
            ApiManager.sharedInstance().getBankList(completion: { (arrClass, strError) in
                if let strError = strError {
                    SVProgressHUD.showError(withStatus: strError)
                    print("Load Data error")
                }else{
                           SVProgressHUD.dismiss()
                    if let list = arrClass?.list {
                        self.bankList = list
                       
                         self.tableView.reloadData()
                  
                    }
                }
            })
        
    }
    
    func loadServiceData(){
        ApiManager.sharedInstance().getServiceList(completion: { (arrClass, strError) in
            if let strError = strError {
                SVProgressHUD.showError(withStatus: strError)
                print("Load Data error")
            }else{
                
                if let list = arrClass?.list {
                    self.serviceList = list
                    SVProgressHUD.dismiss()
                    self.tableView.reloadData()
                }
            }
        })
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
