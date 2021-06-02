//
//  RegisterViewController.swift
//  iPaths
//
//  Created by Lebron on 3/30/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import UIKit
import BetterSegmentedControl
import AlamofireImage

class RegisterViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var cnameLabel: UILabel!
    @IBOutlet weak var ccontactLabel: UILabel!
    @IBOutlet weak var cemailLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var officeLabel: UILabel!
    @IBOutlet weak var rtnLabel: UILabel!
    

    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userPhone: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var userType: BetterSegmentedControl!
    
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var companyView: UIView!
    
    @IBOutlet weak var companyName: UITextField!
    @IBOutlet weak var representative: UITextField!
    @IBOutlet weak var companyEmail: UITextField!
    @IBOutlet weak var contactNumber: UITextField!
    @IBOutlet weak var officeNumber: UITextField!
    @IBOutlet weak var rtn: UITextField!
    @IBOutlet weak var companyPassword: UITextField!
    @IBOutlet weak var verification_code: UITextField!
    
    
    
    @IBOutlet weak var codeView: UIView!
    let imagePicker = UIImagePickerController()
    
    var user_type: String = "user"
    var apiManager: ApiManager?
    var imageUrl: String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        self.codeView.isHidden = true
        
        userType.titles = ["Personal", "Corporativo"]
        userType.titleFont = UIFont(name: "RimouskiLt", size: 25.0)!
        userType.selectedTitleFont = UIFont(name: "RimouskiRg", size: 25.0)!
        
        
        companyView.isHidden = true
        
        nameLabel.font = UIFont(name: "RimouskiRg", size: 23)!
        phoneLabel.font = UIFont(name: "RimouskiRg", size: 23)!
        emailLabel.font = UIFont(name: "RimouskiRg", size: 23)!
        cnameLabel.font = UIFont(name: "RimouskiRg", size: 20)!
        cemailLabel.font = UIFont(name: "RimouskiRg", size: 20)!
        ccontactLabel.font = UIFont(name: "RimouskiRg", size: 20)!
        numberLabel.font = UIFont(name: "RimouskiRg", size: 20)!
        officeLabel.font = UIFont(name: "RimouskiRg", size: 20)!
        rtnLabel.font = UIFont(name: "RimouskiRg", size: 20)!
        
        userName.layer.cornerRadius = 15.0
        
        userEmail.layer.cornerRadius = 15.0
        userPhone.layer.cornerRadius = 15.0
        userPassword.layer.cornerRadius = 15.0
        
        companyName.layer.cornerRadius = 15.0
        representative.layer.cornerRadius = 15.0
        companyEmail.layer.cornerRadius = 15
        contactNumber.layer.cornerRadius = 15
        officeNumber.layer.cornerRadius = 15
        rtn.layer.cornerRadius = 15
        companyPassword.layer.cornerRadius = 15.0
        imagePicker.delegate = self
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func registerUser(_ sender: Any) {
    
        if(validateInput()){
            if(self.user_type == "user"){
                
                let userphone = self.userPhone.text
                
                self.codeView.isHidden = false
                SVProgressHUD.show(withStatus: "Please wait...")
                ApiManager.sharedInstance().verifyCode(phone: userphone!, completion: {(baseModel, strError) in
                    
                    if let strError = strError{
                        SVProgressHUD.showError(withStatus: strError)
                    }
                    else{
                        SVProgressHUD.dismiss()
                        let code = baseModel?.data
                        print(code)
                        UserDefaults.standard.set(baseModel?.data, forKey: "code")
                    }
                })
                
                
            }
            else{
                
                let phone_num = self.contactNumber.text
                self.codeView.isHidden = false
                SVProgressHUD.show(withStatus: "Please wait...")
                ApiManager.sharedInstance().verifyCode(phone: phone_num!, completion: {(baseModel, strError) in
                    if let strError = strError{
                        SVProgressHUD.showError(withStatus: strError)
                    }
                    else{
                        SVProgressHUD.dismiss()
                        UserDefaults.standard.set(baseModel?.data, forKey: "code")
                    }
                })
                
            }
        }
    }
    
    func validateInput() -> Bool{
        
        if(self.user_type == "user"){
            
            if((self.userName.text?.isEmpty)! || (self.userEmail.text?.isEmpty)! || (self.userPhone.text?.isEmpty)! || (self.userPassword.text?.isEmpty)!){
                let alert = UIAlertController(title: "Dito", message: "Empty Field! Please enter your info.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                return false
                
            }
            
            else{
                if(!self.isValidEmail(testStr: self.userEmail.text!)){
                    let alert = UIAlertController(title: "Dito", message: "Invalid Email! Please enter correct email.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    return false
                }
                else{
                    return true
                }
            }
        }
        else{
            
            if((self.companyName.text?.isEmpty)! || (self.companyEmail.text?.isEmpty)! || (self.companyPassword.text?.isEmpty)! || (self.contactNumber.text?.isEmpty)! || (self.officeNumber.text?.isEmpty)! || (self.rtn.text?.isEmpty)!){
                let alert = UIAlertController(title: "Dito", message: "Empty Field! Please enter your info.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                return false
            }
                
            else{
                if(!self.isValidEmail(testStr: self.companyEmail.text!)){
                    let alert = UIAlertController(title: "Dito", message: "Invalid Email!, Please enter correct email.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    return false
                }
                else{
                    return true
                }
            }
        }
        return true

    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        var selectedImage: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"]   as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = originalImage
        }
        if let selectedImages = selectedImage {
            SVProgressHUD.show(withStatus: "Uploading...")
            ApiManager.sharedInstance().addUserPhoto(image: selectedImages, imageName: "photo.jpg", completion: { (res, strError) in
                if let strError = strError {
                    SVProgressHUD.showError(withStatus: strError)
                }else{
                    self.imageUrl = (res?.url)!
                    print(self.imageUrl)
                    SVProgressHUD.dismiss()
                    self.userImage.af_setImage(withURL: URL(string: self.imageUrl)!)
                    self.userImage.layer.cornerRadius = self.userImage.frame.size.height/2
                    self.userImage.clipsToBounds = true
                    self.userImage.layer.borderColor = UIColor.yellow.cgColor
                    self.userImage.layer.borderWidth = 2.0

                }
            })
        }
    }

    @IBAction func chooseImage(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender as! UIButton
            alert.popoverPresentationController?.sourceRect = (sender as! UIButton).bounds
            alert.popoverPresentationController?.permittedArrowDirections = .down
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func openCamera()
    {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Dito", message: "Warning! You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func selectUser(_ sender: Any) {
        if(userView.isHidden == true)
        {
            userView.isHidden = false
            companyView.isHidden = true
            self.user_type = "user"
        }
        else{
            userView.isHidden = true
            companyView.isHidden = false
               self.user_type = "company"
        }
    }
    
    override func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func checkCode(_ sender: Any) {
        
        
        let code = UserDefaults.standard.string(forKey: "code")
        print(code)
        let verify_code = self.verification_code.text
        print(verify_code)
        if(code == verify_code){
            
            if(self.user_type == "user"){
                
                let username = self.userName.text
                let useremail = self.userEmail.text
                let userphone = self.userPhone.text
                let userpwd = self.userPassword.text
                
                if(self.imageUrl.count < 4){
                    self.imageUrl = "http://appdito.ditoexpress.com/upload/avatar.png"
                }
       
                ApiManager.sharedInstance().signup_user(name: username!, password: userpwd!, phone_num: userphone!, email: useremail!, photo: self.imageUrl,  user_type: self.user_type, completion: { (userInfo, strError) in
                    if let strError = strError {
                        SVProgressHUD.showError(withStatus: strError)
                    }else{
                        SVProgressHUD.dismiss()
                        
                        if(userInfo?.status == false){
                            let alert = UIAlertController(title: "Dito", message: "User already exist with your e-mail!", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            self.codeView.isHidden = true
                        }
                        else{
                            UserDefaults.standard.set(true, forKey: Constants.IS_LOGIN)
                            UserDefaults.standard.set(userInfo?.id, forKey: "user_id" )
                            UserDefaults.standard.set(userInfo?.Name, forKey:"user_name")
                            UserDefaults.standard.set(userInfo?.phone, forKey:"user_phone")
                            UserDefaults.standard.set(userInfo?.email, forKey:"user_email")
                            UserDefaults.standard.set(userInfo?.password, forKey:"user_password")
                            UserDefaults.standard.set(userInfo?.photo, forKey:"user_photo")
                            UserDefaults.standard.set(userInfo?.type, forKey:"user_type")
                            //                    let containViewController = ContainerViewController()
                            //                    self.navigationController?.pushViewController(containViewController, animated: true)
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let newViewController = storyBoard.instantiateViewController(withIdentifier: "ContainerViewController") as! ContainerViewController
                            self.present(newViewController, animated: true, completion: nil)
                        }
                        
           
                    }
                })
                
            }
            else{
                let name = self.companyName.text
                let business = self.representative.text
                let email = self.companyEmail.text
                let phone_num = self.contactNumber.text
                let office_num = self.officeNumber.text
                let month_ship = self.rtn.text
                let password = self.companyPassword.text

                ApiManager.sharedInstance().signup_company(name: name!, password: password!, phone_num: phone_num!, email: email!, office_num: office_num!, business: business!, month_ship: month_ship!, user_type: self.user_type, completion: { (userInfo, strError) in
                    if let strError = strError {
                        SVProgressHUD.showError(withStatus: strError)
                    }else{
                        SVProgressHUD.dismiss()
                        UserDefaults.standard.set(true, forKey: Constants.IS_LOGIN)
                        UserDefaults.standard.set(userInfo?.type, forKey:"user_type")
                        UserDefaults.standard.set(userInfo?.id, forKey: "user_id" )
                        UserDefaults.standard.set(userInfo?.Name, forKey:"user_name")
                        UserDefaults.standard.set(userInfo?.phone, forKey:"user_phone")
                        UserDefaults.standard.set(userInfo?.email, forKey:"user_email")
                        UserDefaults.standard.set(userInfo?.password, forKey:"user_password")
                        UserDefaults.standard.set(userInfo?.office_num, forKey:"user_office_num")
                        UserDefaults.standard.set(userInfo?.office_num, forKey:"user_business")
                        UserDefaults.standard.set(userInfo?.office_num, forKey:"user_month_ship")
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ContainerViewController") as! ContainerViewController
                        self.present(newViewController, animated: true, completion: nil)
                    }
                })
            }
            
        }
        else{
            let alert = UIAlertController(title: "Dito", message: "Wrong Verification Code!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.codeView.isHidden = true
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
