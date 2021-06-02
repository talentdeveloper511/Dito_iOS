//
//  LeftSideViewController.swift
//  iPaths
//
//  Created by Lebron on 3/24/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import UIKit
import SideMenu
import AlamofireImage
import BetterSegmentedControl

class LeftSideViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    @IBOutlet weak var tableView: UITableView!
    let menuLabels = ["Home","Rastrear Pedido", "Tarjetas de credito", "Direcciones Favoritas", "Historical", "Contactanos", "Preguntas Frecuentes", "CARRITO", "SALIR"]
    let menuImages = ["sidehome","sidelocation", "sidecredit", "sidefavorite","sidehistory", "sidephone", "sidefaq", "mycart", "sign-out"]
    var selectedId:Int = 0
    
    @IBOutlet weak var sidemenuview: UIView!
    
    @IBOutlet weak var userType: BetterSegmentedControl!
    
    @IBOutlet weak var sideImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sidemenuview.clipsToBounds = true
        sidemenuview.layer.cornerRadius = 10
        
        userType.titles = ["Personal", "Corporativo"]
        userType.titleFont = UIFont(name: "RimouskiLt", size: 19.0)!
        userType.selectedTitleFont = UIFont(name: "RimouskiRg", size: 20.0)!
        let type = UserDefaults.standard.string(forKey: "user_type")
        if(type == "user"){
            do {
                try userType.setIndex(0)
                //all fine with jsonData here
            } catch {
                //handle error
                print(error)
            }
        }else{
            do {
                try userType.setIndex(1)
                //all fine with jsonData here
            } catch {
                //handle error
                print(error)
            }
        }
        
        if #available(iOS 11.0, *) {
            sidemenuview.layer.maskedCorners = [.layerMaxXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
        
        if(UserDefaults.standard.string(forKey: "user_type") == "user"){
            
                if let url = UserDefaults.standard.string(forKey: "user_photo"){
                    print(url)
                    if(url.count > 5){
                        sideImage.af_setImage(withURL: URL(string:url)!)
                    }
                    else{
                        sideImage.image = UIImage(named: "avatar")
                    }
                }
 
            

            sideImage.layer.cornerRadius = sideImage.layer.frame.size.height/2
            sideImage.layer.borderColor = UIColor.yellow.cgColor
            sideImage.layer.borderWidth = 2.0
        }
        else{
            sideImage.image = UIImage(named: "sidelogo")
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        selectedId = -1
    }
    @IBAction func editProfile(_ sender: Any) {
        
        self.selectedId = 100
        dismiss(animated: true, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuLabels.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItem") as! MenuItemTVCell
        cell.menuLabel.text = menuLabels[indexPath.row]
        cell.menuImage.image = UIImage.init(named: menuImages[indexPath.row])
        return cell
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedId = indexPath.row
        dismiss(animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func changeAccount(_ sender: Any) {
        
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Dito", message: "Enter your login info", preferredStyle: .alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (email_tf) in
                email_tf.placeholder = "Email"
            }
            alert.addTextField { (pwd_tf) in
                pwd_tf.placeholder = "Password"
            }
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                
                
                let email_text = alert?.textFields![0] as! UITextField
                let pwd_text = alert?.textFields![1] as! UITextField
                
                
                
                ApiManager.sharedInstance().login(email: email_text.text!, password: pwd_text.text!,completion: { (userInfo, strError) in
                    if let strError = strError {
                        SVProgressHUD.showError(withStatus: strError)
                    }else{
                        SVProgressHUD.dismiss()
                        let status = userInfo?.status
                        
                        if(status)!{
                            print(userInfo?.status)
                            
                            print(userInfo?.id)
                            UserDefaults.standard.set(true, forKey: Constants.IS_LOGIN)
                            //                    UserDefaults.standard.set(userInfo, forKey:"userinfo")
                            UserDefaults.standard.set(userInfo?.type, forKey: "user_type" )
                            let userType = UserDefaults.standard.string(forKey: "user_type")
                            
                            print(userType)
                            
                            if(userType == "user"){
                                UserDefaults.standard.set(userInfo?.id, forKey: "user_id" )
                                UserDefaults.standard.set(userInfo?.Name, forKey:"user_name")
                                UserDefaults.standard.set(userInfo?.phone, forKey:"user_phone")
                                UserDefaults.standard.set(userInfo?.email, forKey:"user_email")
                                UserDefaults.standard.set(userInfo?.password, forKey:"user_password")
                                UserDefaults.standard.set(userInfo?.photo, forKey:"user_photo")
                            }
                            else{
                                UserDefaults.standard.set(userInfo?.id, forKey: "user_id" )
                                UserDefaults.standard.set(userInfo?.Name, forKey:"user_name")
                                UserDefaults.standard.set(userInfo?.phone, forKey:"user_phone")
                                UserDefaults.standard.set(userInfo?.email, forKey:"user_email")
                                UserDefaults.standard.set(userInfo?.password, forKey:"user_password")
                                UserDefaults.standard.set(userInfo?.office_num, forKey:"user_office_num")
                                UserDefaults.standard.set(userInfo?.office_num, forKey:"user_business")
                                UserDefaults.standard.set(userInfo?.office_num, forKey:"user_month_ship")
                            }
                            self.dismiss(animated: true, completion: nil)
                            
                        }else{
                            
                            if(self.userType.index == 0){
                                do {
                                    try self.userType.setIndex(1)
                                    //all fine with jsonData here
                                } catch {
                                    //handle error
                                    print(error)
                                }
                            }
                            
                            else{
                                do {
                                    try self.userType.setIndex(0)
                                    //all fine with jsonData here
                                } catch {
                                    //handle error
                                    print(error)
                                }
                            }
                            
                            SVProgressHUD.dismiss()
                            let alert = UIAlertController(title: "Dito", message: "Login Failed! Please enter correct Info.", preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            
                            self.present(alert, animated: true)
                            self.dismiss(animated: true, completion: nil)
                        }
                        
                    }
                })
            }))

            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
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
