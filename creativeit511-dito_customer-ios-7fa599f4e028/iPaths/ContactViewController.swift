//
//  ContactViewController.swift
//  iPaths
//
//  Created by Lebron on 3/26/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {

    @IBOutlet weak var contactTitle: UILabel!
    @IBOutlet weak var telTitle: UILabel!
    @IBOutlet weak var telNumber: UILabel!
    @IBOutlet weak var emailTitle: UILabel!
    @IBOutlet weak var email: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadURL()
        contactTitle.font = UIFont(name: "RimouskiRg-Regular2", size: 39)
        telTitle.font = UIFont(name: "RimouskiRg-Regular", size: 37)
        emailTitle.font = UIFont(name: "RimouskiLt-Regular", size: 33)
        telNumber.font = UIFont(name: "RimouskiLt-Regular", size: 33)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadURL(){
        ApiManager.sharedInstance().getSupportInfo(completion: {(arrClass, strErr) in
            if let strErr = strErr {
                SVProgressHUD.showError(withStatus: strErr)
            }
            else{
                SVProgressHUD.dismiss()
                if let list = arrClass?.list{
                    self.email.text = list[0].email
                    self.telNumber.text = list[0].phone
                    
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
