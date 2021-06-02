//
//  ThanksViewController.swift
//  iPaths
//
//  Created by Jackson on 5/16/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import UIKit

class ThanksViewController: UIViewController {

    @IBOutlet weak var orderbtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        formatLocalData()
        self.orderbtn.layer.cornerRadius = self.orderbtn.layer.frame.size.height/2
        UserDefaults.standard.set("", forKey: "pick_reg")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func orderTrack(_ sender: Any) {
        let vc = self.parent as! ContainerViewController
        let trackViewController = storyboard?.instantiateViewController(withIdentifier: "TrackViewController") as! TrackViewController
        vc.addChildViewController(trackViewController)
        vc.containerView.addSubview(trackViewController.view)
    }
    
    func formatLocalData(){
        SVProgressHUD.show(withStatus: "Loading")
         UserDefaults.standard.set("", forKey: "pick_reg")
        UserDefaults.standard.set("", forKey: "product_order")
        UserDefaults.standard.set("", forKey: "")
                UserDefaults.standard.set("", forKey: "delAddr")
                UserDefaults.standard.set("", forKey: "order_deli_lat")
                UserDefaults.standard.set("", forKey: "order_deli_long")
                UserDefaults.standard.set("", forKey: "pickAddr")
                UserDefaults.standard.set("", forKey: "order_pick_lat")
                UserDefaults.standard.set("", forKey: "order_pick_long")
                UserDefaults.standard.set("", forKey: "pickAddrReg")
                UserDefaults.standard.set("", forKey: "deliAddrReg")
                UserDefaults.standard.set("", forKey: "finalAddrReg")
                UserDefaults.standard.set("", forKey: "order_final_lat")
                UserDefaults.standard.set("", forKey: "order_final_long")
                UserDefaults.standard.set("", forKey: "order_pick_addr")
                UserDefaults.standard.set("", forKey: "order_pick_addr")
                UserDefaults.standard.set("", forKey: "cart_name")
                UserDefaults.standard.set("", forKey: "order_amount")
                UserDefaults.standard.set("", forKey: "order_start_time")
                UserDefaults.standard.set("", forKey: "order_amount")
                UserDefaults.standard.set("", forKey: "cart_name")
                UserDefaults.standard.set("", forKey: "order_pick_lugar")
                UserDefaults.standard.set("", forKey: "order_deli_lugar")
        UserDefaults.standard.set("", forKey: "order_final_lugar")
        UserDefaults.standard.set("", forKey: "order_contact_name")
        UserDefaults.standard.set("", forKey: "order_contact_num")
                SVProgressHUD.dismiss()
        
        
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
