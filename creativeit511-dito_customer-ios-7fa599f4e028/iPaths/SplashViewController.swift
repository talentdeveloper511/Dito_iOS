//
//  SplashViewController.swift
//  iPaths
//
//  Created by Lebron on 3/23/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import UIKit
import SendBirdSDK

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let path = Bundle.main.path(forResource: "Info", ofType: "plist")
        if path != nil {
            let infoDict = NSDictionary(contentsOfFile: path!)
            let sampleUIVersion = infoDict?["CFBundleShortVersionString"] as! String
            let version = String(format: "Sample UI v%@ / SDK v%@", sampleUIVersion, SBDMain.getSDKVersion())
            
        }
    }

    @IBAction func goTo(_ sender: Any) {
        
        let login = UserDefaults.standard.bool(forKey: Constants.IS_LOGIN)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if login != nil, login == true{
            let name = UserDefaults.standard.string(forKey: "user_name") ?? ""
            let email = UserDefaults.standard.string(forKey: "user_email") ?? ""
            connect(email: email, name: name)
        } else{
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.present(nextViewController, animated:true, completion:nil)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func connect(email:String, name:String) {
        
        ConnectionManager.login(userId: email, nickname: name) { (user, error) in
            guard error == nil else {
                return
            }

            DispatchQueue.main.async {
                let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "ContainerViewController") as! ContainerViewController
                self.present(nextViewController, animated:true, completion:nil)
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
