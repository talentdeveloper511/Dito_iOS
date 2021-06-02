//
//  LoginViewController.swift
//  iPaths
//
//  Created by Lebron on 3/26/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import UIKit

//import FacebookLogin
//import FacebookCore
import CoreData
//import FBSDKShareKit
//import FBSDKLoginKit
import SVProgressHUD


class LoginViewController: UIViewController {
    var Lclsocialname = ""
    var LclsocialID = ""
    var LclsocialEmail = ""
    var apiManager: ApiManager?
    
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
    }
    
    override func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginFacebook(_ sender: Any) {
//        self.loginButtonClicked()
    }
    
    @objc func loginButtonClicked() {
        

    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @IBAction func login(_ sender: Any) {
        
        let email = self.userEmail.text
        let password = self.userPassword.text
        SVProgressHUD.show(withStatus: "Login...")
        if(self.isValidEmail(testStr: email!)){
            ApiManager.sharedInstance().login(email: email!, password: password!,completion: { (userInfo, strError) in
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
                            UserDefaults.standard.set(userInfo?.business, forKey:"user_business")
                            UserDefaults.standard.set(userInfo?.month_ship, forKey:"user_month_ship")
                            UserDefaults.standard.set(userInfo?.current_state, forKey:"user_current")
                        }
                        self.connect(email: (userInfo?.email)!, name: (userInfo?.Name)!)
                    }else{
                        SVProgressHUD.dismiss()
                        let alert = UIAlertController(title: "Dito", message: "Login Failed! Please enter correct Info.", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        
                        self.present(alert, animated: true)
                    }
                    
                }
            })
        }
        else{
            SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Dito", message: "Invalid Email, Please enter correct email.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
        
        
        

    }
    func connect(email:String, name:String) {
        
//        ConnectionManager.login(userId: email, nickname: name) { (user, error) in
//            guard error == nil else {
//                return
//            }
//
//            DispatchQueue.main.async {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "ContainerViewController") as! ContainerViewController
                self.present(newViewController, animated: true, completion: nil)
//            }
//        }
    }
    
//    func getuaerinfofromfacebook()
//    {
//        let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, gender , name, first_name, last_name, picture.type(large), email"])
//
//        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
//
//            if ((error) != nil)
//            {
//                print("Error: \(String(describing: error))")
//            }
//            else
//            {
//                print(result!)
//
//                // let userdat = result as
//                let data:[String:Any] = result as! [String : Any]
//
//
//                let  name  =   (data as AnyObject).object(forKey:"name") as! String
//                let  id  =   (data as AnyObject).object(forKey:"id") as! String
//                let  email  = id + "faceok.com"
//                self.Lclsocialname = name
//                self.LclsocialID = id
//                self.LclsocialEmail = email
//                self.SocialLoginapi(socialid: self.LclsocialID, SocialParam: "facebook_id", Socialurl: "Account/facebook_login", resultcode: 4)
//
//            }
//        })
//
//    }
//
    func SocialLoginapi(socialid:String,SocialParam:String,Socialurl:String,resultcode:Int)
    {

        
        //
        //        ApiManagerClass.APimanagerobject.protocoloobject = self as! Apiprotocolclass
        //        ApiManagerClass.APimanagerobject.Withparamapi(apiurl: Socialurl, resultcode: resultcode, dic: dic )
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


