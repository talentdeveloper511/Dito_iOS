//
//  CorporateProfileViewController.swift
//  iPaths
//
//  Created by Marko Dreher on 6/8/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import UIKit

class CorporateProfileViewController: UIViewController {
    
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var representText: UITextField!
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var contactText: UITextField!
    
    @IBOutlet weak var officeText: UITextField!
    
    @IBOutlet weak var rtnText: UITextField!
    
    @IBOutlet weak var pwdText: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    var messageStr: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.saveBtn.layer.cornerRadius = self.saveBtn.layer.frame.height/2
        initData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initData(){
        self.nameText.text = UserDefaults.standard.string(forKey: "user_name")
        self.representText.text  = UserDefaults.standard.string(forKey: "user_business")
        self.emailText.text = UserDefaults.standard.string(forKey: "user_email")
        self.contactText.text = UserDefaults.standard.string(forKey: "user_phone")
        self.officeText.text = UserDefaults.standard.string(forKey: "user_office_num")
        self.rtnText.text = UserDefaults.standard.string(forKey: "user_month_ship")
        if let password = UserDefaults.standard.string(forKey: "user_password"){
        self.pwdText.text = password
        }
        
        
        
    }
    @IBAction func updateCorporate(_ sender: Any) {

        if(checkValidation()){
            let user_id = UserDefaults.standard.string(forKey: "user_id")
            let user_name = nameText.text
            let user_pwd =  pwdText.text
            let phone_num = contactText.text
            let email = emailText.text
            let office_num = officeText.text
            let business = representText.text
            let month_ship = rtnText.text
            SVProgressHUD.show(withStatus: "Please wait...")
            ApiManager.sharedInstance().update_company(user_id: user_id!, name: user_name!, password: user_pwd!, phone_num: phone_num!, email: email!, office_num: office_num!, business: business!, month_ship: month_ship!, current: UserDefaults.standard.string(forKey: "user_current")!, completion: { (userInfo, strError) in
                if let strError = strError {
                    SVProgressHUD.showError(withStatus: strError)
                }else{
                    SVProgressHUD.dismiss()
                    UserDefaults.standard.set(true, forKey: Constants.IS_LOGIN)
                    //                    let containViewController = ContainerViewController()
                    //                    self.navigationController?.pushViewController(containViewController, animated: true)
                    
                    if(userInfo?.status)!{
                        if let id = userInfo?.id{
                            print(id)
                            UserDefaults.standard.set(id, forKey: "user_id" )
                        }
                        
                        if let name = userInfo?.Name {
                            print(name)
                            UserDefaults.standard.set(name, forKey:"user_name")
                        }
                        
                        if let phone = userInfo?.phone {
                            UserDefaults.standard.set(userInfo?.phone, forKey:"user_phone")
                        }
                        print(userInfo?.phone)
                        UserDefaults.standard.set(userInfo?.email, forKey:"user_email")
                        UserDefaults.standard.set(userInfo?.password, forKey:"user_password")
                        UserDefaults.standard.set(userInfo?.office_num, forKey:"user_office_num")
                        UserDefaults.standard.set(userInfo?.business, forKey:"user_business")
                        UserDefaults.standard.set(userInfo?.month_ship, forKey:"user_month_ship")
                    }
                    

                    let vc = self.parent as! ContainerViewController
                    let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                    vc.addChildViewController(mainViewController)
                    vc.containerView.addSubview(mainViewController.view)
                }
            })
            
        }
        else{
            let alert = UIAlertController(title: "Update Profile Failed!", message: self.messageStr, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
        
    }
    
    func checkValidation() -> Bool {
        if((nameText.text?.count)! > 0 && (representText.text?.count)! > 0 && (emailText.text?.count)! > 0 && (contactText.text?.count)! > 0 && (officeText.text?.count)! > 0 && (rtnText.text?.count)! > 0 && (pwdText.text?.count)! > 0 ){
            
            if(isValidEmail(testStr: emailText.text!)){
                
                return true
            }
            else{
                self.messageStr = "Wrong Email Type"
                return false
            }
            
        }
        else{
            self.messageStr = "Please Fill out all forms"
            return false
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    /*
     MARK: - Navigation

     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         Get the new view controller using segue.destinationViewController.
         Pass the selected object to the new view controller.
    }
    */

}
