//
//  ProfileEditViewController.swift
//  iPaths
//
//  Created by Jackson on 5/10/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class ProfileEditViewController: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var name: UITextField!
    let imagePicker = UIImagePickerController()
    var apiManager: ApiManager?
    var imageURL:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))        // Do any additional setup after loading the view.
        view.addGestureRecognizer(tap)
        phoneNumber.layer.cornerRadius = 15.0
        email.layer.cornerRadius = 15
        password.layer.cornerRadius = 15.0
        if let url = UserDefaults.standard.string(forKey: "user_photo"){
            imageURL = url
        }
        saveBtn.layer.cornerRadius = 15.0
        closeBtn.layer.cornerRadius = 15.0
        imagePicker.delegate = self
        loadData()
    }
    
    override func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backTo(_ sender: Any) {
        let vc = self.parent as! ContainerViewController
        let mainViewController = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        vc.addChildViewController(mainViewController)
        vc.containerView.addSubview(mainViewController.view)
    }
    
    func loadData(){
        SVProgressHUD.show(withStatus: "Loading Data..")
        
        if let name = UserDefaults.standard.string(forKey: "user_name"){
            self.name.text = name
        }
        
        if(UserDefaults.standard.string(forKey: "user_photo") != nil){
            self.avatarImage.af_setImage(withURL: URL(string: UserDefaults.standard.string(forKey: "user_photo")!)!)
        }
        else{
            self.avatarImage.image = UIImage(named: "avatar")
        }
        self.avatarImage.layer.cornerRadius = self.avatarImage.layer.frame.size.height/2
        self.avatarImage.layer.borderColor = UIColor.yellow.cgColor
        self.avatarImage.layer.borderWidth = 2
        self.avatarImage.clipsToBounds = true
        
        if let phone_number = UserDefaults.standard.string(forKey: "user_phone"){
            self.phoneNumber.text = phone_number
        }
        
        self.email.text = UserDefaults.standard.string(forKey: "user_email")
        self.password.text = UserDefaults.standard.string(forKey: "user_password")
        
        SVProgressHUD.dismiss()
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        
        let username = self.name.text
        let useremail = self.email.text
        let userphone = self.phoneNumber.text
        let userpwd = self.password.text
        let userphoto = self.imageURL
        let user_id = UserDefaults.standard.string(forKey: "user_id")
        ApiManager.sharedInstance().update_user(user_id: user_id!, name: username!, password: userpwd!, phone_num: userphone!, email: useremail!, photo: userphoto!,  completion: { (userInfo, strError) in
            if let strError = strError {
                SVProgressHUD.showError(withStatus: strError)
            }else{
                SVProgressHUD.dismiss()
                UserDefaults.standard.set(true, forKey: Constants.IS_LOGIN)
                
                if(userInfo?.status)!{
                    if let id = userInfo?.id {
                        UserDefaults.standard.set(id, forKey: "user_id" )
                    }
                    
                    if let user_name = userInfo?.Name {
                        UserDefaults.standard.set(user_name, forKey:"user_name")
                    }
                    
                    if let user_phone = userInfo?.phone {
                        UserDefaults.standard.set(user_phone, forKey:"user_phone")
                    }
                    if let user_email = userInfo?.email{
                        UserDefaults.standard.set(user_email, forKey:"user_email")
                    }
                    
                    if let user_pwd = userInfo?.password{
                        UserDefaults.standard.set(user_pwd, forKey:"user_password")
                    }
                    
                    if let user_photo = userInfo?.photo {
                        UserDefaults.standard.set(user_photo, forKey:"user_photo")
                    }
                }



            }
        })
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
                    self.imageURL = res?.url
                    
                    SVProgressHUD.dismiss()
                    self.avatarImage.af_setImage(withURL: URL(string: self.imageURL!)!)
                    self.avatarImage.layer.cornerRadius = self.avatarImage.frame.size.height/2
                    self.avatarImage.clipsToBounds = true
                    self.avatarImage.layer.borderColor = UIColor.yellow.cgColor
                    self.avatarImage.layer.borderWidth = 2.0
                    
                    
                }
            })
        }
    }
    
    

    
    
    @IBAction func close(_ sender: Any) {
        
        let vc = self.parent as! ContainerViewController
        let mainViewController = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        vc.addChildViewController(mainViewController)
        vc.containerView.addSubview(mainViewController.view)
    }
    @IBAction func editPicture(_ sender: Any) {
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
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
