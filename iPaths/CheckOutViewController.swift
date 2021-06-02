//
//  CheckOutViewController.swift
//  iPaths
//
//  Created by Lebron on 3/28/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import UIKit
import M13Checkbox
import Stripe
import CCValidator
import DropDown


class CheckOutViewController: UIViewController {

    @IBOutlet weak var checkoutBtn: UIButton!
    @IBOutlet weak var checkoutValue: UILabel!
    
    @IBOutlet weak var checkoutNum: UILabel!
    
    @IBOutlet weak var checkoutName: UITextField!
    @IBOutlet weak var checkoutCVC: UILabel!
    


    
    @IBOutlet weak var cardNumber: UITextField!
    @IBOutlet weak var CVC: UITextField!
    @IBOutlet weak var selectCard: UITextField!
    
    @IBOutlet weak var checkoutDateLabel: UILabel!
    @IBOutlet weak var checkoutCheckTitle: UILabel!
    @IBOutlet weak var checkBox: M13Checkbox!
    @IBOutlet weak var checkoutDate: UITextField!
    @IBOutlet weak var amountValue: UILabel!
    

    var cards: [CardModel] = []
    var cardNames: [CardName] = []
    var cardDropDown = DropDown()
    var favoriteCard: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        DropDown.startListeningToKeyboard()
        // Do any additional setup after loading the view.
        self.checkoutBtn.titleLabel?.font = UIFont(name: "RimouskiRg",size: 20.0)!
        
        checkoutValue.font = UIFont(name: "RimouskiRg",size: 33.0)!
        checkoutNum.font =  UIFont(name: "RimouskiRg",size: 20.0)!
        checkoutName.font =  UIFont(name: "RimouskiRg",size: 20.0)!
        checkoutCVC.font =  UIFont(name: "RimouskiRg",size: 20.0)!
        checkoutDateLabel.font = UIFont(name: "RimouskiRg",size: 20.0)!
        checkoutCheckTitle.font =  UIFont(name: "RimouskiRg",size: 20.0)!
        
        checkBox.boxType = .circle
        
        let price = UserDefaults.standard.string(forKey: "order_amount")!
        
        if(price.contains(".")){
            self.checkoutValue.text = UserDefaults.standard.string(forKey:"order_amount")! + "Lps"
        }else{
            self.checkoutValue.text = price + ".00Lps"
        }
        
        selectCard.layer.cornerRadius = selectCard.layer.frame.size.height/2
        selectCard.clipsToBounds = true
        self.cardNumber.layer.cornerRadius = cardNumber.layer.frame.size.height/2
        cardNumber.clipsToBounds = true
        self.CVC.layer.cornerRadius = CVC.layer.frame.size.height/2
        CVC.clipsToBounds = true
        
        self.checkoutName.layer.cornerRadius = checkoutName.layer.frame.size.height/2
        checkoutDate.clipsToBounds = true
        self.checkoutDate.layer.cornerRadius = checkoutDate.layer.frame.size.height/2
        checkoutName.clipsToBounds = true
        
        
        self.cardDropDown.direction = .bottom
        self.cardDropDown.layer.cornerRadius = self.selectCard.layer.frame.size.height/2
        self.cardDropDown.clipsToBounds = true
        loadCardData();
        
       
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    func loadCardData(){
        
        self.cardDropDown.anchorView = selectCard
        //self.cardDropDown.toolbarPlaceholder = "Select a Card"
        
        SVProgressHUD.show(withStatus: "Please wait...")
        let user_id = UserDefaults.standard.string(forKey: "user_id")
        
        ApiManager.sharedInstance().getCardNameList(user_id: user_id!, completion: { (arrClass, strError) in
            if let strError = strError {
                SVProgressHUD.showError(withStatus: strError)
                print("Load Data error")
            }else{
                SVProgressHUD.dismiss()
                if let list = arrClass?.list {
                    self.cardNames = list
                    for name in self.cardNames{
                        self.cardDropDown.dataSource.append(name.cardName!)
                        
                    }
                    
                    self.cardDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                        ApiManager.sharedInstance().getCardInfo(user_id: user_id!, card_name: item, completion:{(cardList, strError) in
                            if let strError = strError{
                                SVProgressHUD.showError(withStatus: strError)
                                print("Load Data error")
                            }
                            else{
                                if let list = cardList?.list {
                                    self.cards = list
                                    self.selectCard.text = self.cards[0].cardName
                                    self.checkoutName.text = self.cards[0].cardName
                                    self.cardNumber.text = self.cards[0].cardNum
                                    self.CVC.text = self.cards[0].cardCVC
                                    self.checkoutDate.text = self.cards[0].cardDate
             
                            }
                            } })
                        
                        
                    }

                }
            }
        })
    }
    

    @IBAction func showDropDown(_ sender: Any) {
        self.cardDropDown.show()
    }
    
    override func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func formValidation() -> Bool{
        let cardNumber = self.cardNumber.text
        return CCValidator.validate(creditCardNumber: cardNumber!)
        
    }
    @IBAction func checkedAgregar(_ sender: Any) {
        
        
        
        if(self.checkBox.checkState == .checked){
            self.favoriteCard = true
        }
        else{
            self.favoriteCard = false
        }
        
    }
    @IBAction func textFieldEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(CheckOutViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
       
        var exp = dateFormatter.string(from: sender.date).components(separatedBy: "/")
        checkoutDate.text = exp[0] + "/" + exp[2]

        
    }
    
    
    func getCreditInfo(){
        ApiManager.sharedInstance().getCompanyInfo(id: UserDefaults.standard.string(forKey: "user_id")!,completion: { (userInfo, strError) in
            if let strError = strError {
                SVProgressHUD.showError(withStatus: strError)
            }else{
                SVProgressHUD.dismiss()
      
                        var limit = 0.00
                        var current_state = 0.00
                
                        print(userInfo?.limit?.count)
                if let length = userInfo?.limit?.count{
                    if length > 1{
                        
                        var str_temp = userInfo?.limit?.removingCharactersInSet(CharacterSet(charactersIn: ","))
                            if let limit_temp =  Double(str_temp!){
                                limit = limit_temp
                            }
                            
                            if(userInfo?.current_state != nil){
                                
                                if let current_temp = Double((userInfo?.current_state)!){
                                    current_state = current_temp
                                }
                            }
                            
                            print(current_state)
                            
                            var temp = 0.00
                            if let amount = UserDefaults.standard.string(forKey:"order_amount"){
                                
                                
                                print(amount)
                                temp = Double(amount)!
                            }
                            if((limit - current_state) > temp){
                                ApiManager.sharedInstance().update_company(user_id: UserDefaults.standard.string(forKey: "user_id")!, name: UserDefaults.standard.string(forKey: "user_name")!, password: UserDefaults.standard.string(forKey: "user_password")!, phone_num: UserDefaults.standard.string(forKey: "user_phone")!, email: UserDefaults.standard.string(forKey: "user_email")!, office_num: UserDefaults.standard.string(forKey: "user_office_num")!, business: UserDefaults.standard.string(forKey: "user_business")!, month_ship: UserDefaults.standard.string(forKey: "user_month_ship")!, current:String(current_state + temp), completion: { (userInfo, strError) in
                                    if let strError = strError {
                                        SVProgressHUD.showError(withStatus: strError)
                                    }else{
                                        SVProgressHUD.dismiss()}
                                    self.addOrder()
                                })
                            }
                            else{
                                let alert = UIAlertController(title: "Dito", message: "Payment Failed, Your rest credit is not enough! \(limit - current_state)Lps", preferredStyle: .alert)
                                
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                
                                self.present(alert, animated: true)
                            }
               
                            
                        }
                        
                        else{
                            let alert = UIAlertController(title: "Dito", message: "Payment failed, Your credit is not approved, yet!", preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            
                            self.present(alert, animated: true)
                        }
                    
                }
                        
              
                
            }
            
        })
    }
    
    @IBAction func checkout(_ sender: Any) {
        SVProgressHUD.show(withStatus: "Please wait...")
        
        if let count = self.CVC.text?.count{
            
            if count > 4{
                
                self.getCreditInfo()
            }
            
            else{
                if(formValidation()){
                    
                    
                    let cardParams = STPCardParams()
                    cardParams.number = self.cardNumber.text
                    var exp = checkoutDate.text?.components(separatedBy: "/")
                    var temp = "0"
                    if(exp![0].count < 2){
                        temp = temp + exp![0]
                        cardParams.expMonth = UInt(temp)!
                    }
                    else{
                        cardParams.expMonth = UInt(exp![0])!
                    }
                    
                    cardParams.expYear = UInt(exp![1])!
                    print(cardParams.expYear)
                    print(cardParams.expMonth)
                    cardParams.cvc = self.CVC.text
                    
                    STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
                        guard let token = token, error == nil else {
                            // Present error to user...
                            
                            print(error)
//                                                SVProgressHUD.showError(withStatus: "\(error)")
                            SVProgressHUD.showError(withStatus: "Card Token Error")
                            return
                        }
                        print(token)
                        print(Int(UserDefaults.standard.string(forKey: "order_amount")!))
                        if let amount = Int(UserDefaults.standard.string(forKey: "order_amount")!){
                            StripeClient.shared.completeCharge(with: token, amount: Int(UserDefaults.standard.string(forKey: "order_amount")!)!) { result in
                                switch result {
                                // 1
                                case .success:
                                    
                                    if(self.favoriteCard ==  true){
                                        let user_id = UserDefaults.standard.string(forKey: "user_id")
                                        SVProgressHUD.show(withStatus: "Please wait...")
                                        
                                        ApiManager.sharedInstance().addCreditCard(cardName: self.checkoutName.text!, cardNum: self.cardNumber.text!, cardDate: self.checkoutDate.text!, cardCVC: self.CVC.text!, user_id: user_id!, completion: {(arrClass, strError) in
                                            if let strError = strError {
                                                SVProgressHUD.showError(withStatus: strError)
                                                print("Load Data error")
                                            }else{
                                                print(arrClass)
                                                SVProgressHUD.dismiss()
                                            }
                                        })
                                        
                                    }
                                    
                                    self.addOrder()
                                    
                                // 2
                                case .failure(let error):
                                    SVProgressHUD.showError(withStatus: "Credit Card Check Failed, Please, try again")
                                    print(error)
                                    break;
                                    
                                }
                            }
                        }
                    }

                }
                else{
                    SVProgressHUD.dismiss()
                    let alertController = UIAlertController(title: "Dito", message: "Card Error, Unknown Type!", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    
                }
            }
        }


        
        
    }
    
    
    func addOrder(){
        let order_type = UserDefaults.standard.string(forKey: "order_type")
        let order_user_id = UserDefaults.standard.string(forKey: "user_id")
        let order_amount = UserDefaults.standard.string(forKey: "order_amount")
        let order_start_time = self.getCurrentTime()
        let email = UserDefaults.standard.string(forKey: "user_email")
        
        switch order_type{
        case "Product_Order":
            ApiManager.sharedInstance().addOrderProduct(order_user_id: order_user_id!, order_start_time: order_start_time, order_delivery_address: UserDefaults.standard.string(forKey: "delAddr")!, order_type: order_type!, order_amount: order_amount!, order_delivery_lat: UserDefaults.standard.string(forKey: "order_deli_lat")!, order_delivery_long: UserDefaults.standard.string(forKey: "order_deli_long")!, cart_name: UserDefaults.standard.string(forKey: "cart_name")!, email: email!,order_contact_name: UserDefaults.standard.string(forKey: "order_contact_name")!,order_contact_num: UserDefaults.standard.string(forKey: "order_contact_num")! , completion:{ (baseModel,strError) in
                
                if let strError = strError{
                    SVProgressHUD.showError(withStatus: strError)
                }
                else{
                    SVProgressHUD.dismiss()
                    self.goToThankView()
                }
            })
            break
        case "Ida":
            ApiManager.sharedInstance().addOrderIda(order_user_id: order_user_id!, order_start_time: order_start_time, order_pick_address: UserDefaults.standard.string(forKey: "pickAddr")!, order_delivery_address: UserDefaults.standard.string(forKey: "delAddr")!, order_type: order_type!, order_amount: order_amount!, order_pick_lat: UserDefaults.standard.string(forKey: "order_pick_lat")!, order_pick_long: UserDefaults.standard.string(forKey: "order_pick_long")!, order_delivery_lat: UserDefaults.standard.string(forKey: "order_deli_lat")!, order_delivery_long: UserDefaults.standard.string(forKey: "order_deli_long")!,order_pick_lugar: UserDefaults.standard.string(forKey: "order_pick_lugar")!,order_deli_lugar: UserDefaults.standard.string(forKey: "order_deli_lugar")!, order_contact_name: UserDefaults.standard.string(forKey: "order_contact_name")!,order_contact_num: UserDefaults.standard.string(forKey: "order_contact_num")! , email: email!,
                                                    completion: {(baseModel, strError) in
                                                        
                                                        if let strError = strError{
                                                            SVProgressHUD.showError(withStatus: strError)
                                                        }
                                                        else{
                                                            SVProgressHUD.dismiss()
                                                            self.goToThankView()
                                                        }
            })
            break
            
        case "Reg":
            ApiManager.sharedInstance().addOrderReg(order_user_id: order_user_id!, order_start_time: order_start_time, order_pick_address: UserDefaults.standard.string(forKey: "pickAddrReg")!, order_delivery_address: UserDefaults.standard.string(forKey: "deliAddrReg")!, order_mid_address: UserDefaults.standard.string(forKey: "finalAddrReg")!, order_type: order_type!, order_amount: order_amount!, order_pick_lat: UserDefaults.standard.string(forKey: "order_pick_lat")!, order_pick_long: UserDefaults.standard.string(forKey: "order_pick_long")!, order_delivery_lat: UserDefaults.standard.string(forKey: "order_deli_lat")!, order_delivery_long: UserDefaults.standard.string(forKey: "order_deli_long")!, order_mid_lat: UserDefaults.standard.string(forKey: "order_final_lat")!, order_mid_long: UserDefaults.standard.string(forKey: "order_final_long")!,order_pick_lugar: UserDefaults.standard.string(forKey: "order_pick_lugar")!,order_deli_lugar: UserDefaults.standard.string(forKey: "order_deli_lugar")!,order_final_lugar:
                UserDefaults.standard.string(forKey: "order_final_lugar")!,order_contact_name: UserDefaults.standard.string(forKey: "order_contact_name")!,order_contact_num: UserDefaults.standard.string(forKey: "order_contact_num")! , email: email!, completion: {(baseModel, strErr) in
                    if let strErr = strErr{
                        SVProgressHUD.showError(withStatus: strErr)
                    }
                    else{
                        self.goToThankView()
                        SVProgressHUD.dismiss()
                    }
            })
            break
        default:
            ApiManager.sharedInstance().addOrderService(order_user_id: order_user_id!, order_start_time: order_start_time, order_pick_address: UserDefaults.standard.string(forKey: "order_pick_addr")!, order_type: order_type!, order_amount: order_amount!, order_pick_lat: UserDefaults.standard.string(forKey: "order_pick_lat")!, order_pick_long: UserDefaults.standard.string(forKey: "order_pick_long")!, email: email!, order_contact_name: UserDefaults.standard.string(forKey: "order_contact_name")!,order_contact_num: UserDefaults.standard.string(forKey: "order_contact_num")!, completion:{ (baseModel,strError) in
                
                if let strError = strError{
                    SVProgressHUD.showError(withStatus: strError)
                }
                else{
                    self.goToThankView()
                    SVProgressHUD.dismiss()
                }
            })
            break
            
        }
        
        
    }
    
    func goToThankView(){
        SVProgressHUD.dismiss()
        let alertController = UIAlertController(title: "Dito", message: "Congrats!, Your payment was successful.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            let vc = self.parent as! ContainerViewController
            let thanksViewController = self.storyboard?.instantiateViewController(withIdentifier: "ThanksViewController") as! ThanksViewController
            vc.addChildViewController(thanksViewController)
            vc.containerView.addSubview(thanksViewController.view)
        })
        alertController.addAction(alertAction)
        self.present(alertController, animated: true)
    }
    
    func getCurrentTime() -> String{
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        
        
        return String(hour) + ":" + String(minutes) + ":" + String(second)
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

/*
 func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
 {
 //Range.Lenth will greater than 0 if user is deleting text - Allow it to replce
 if range.length > 0
 {
 return true
 }
 
 //Dont allow empty strings
 if string == " "
 {
 return false
 }
 
 //Check for max length including the spacers we added
 if range.location >= 5
 {
 return false
 }
 
 var originalText = textField.text
 
 let replacementText = string.replacingOccurrences(of:" ", with: "")
 
 //Verify entered text is a numeric value
 let digits = NSCharacterSet.decimalDigits
 for char in replacementText.unicodeScalars
 {
 if !digits.longCharacterIsMember(char.value)
 {
 return false
 }
 }
 
 //Put / space after 2 digit
 if range.location == 2
 {
 originalText?.append(contentsOf: "/")
 //            originalText?.appendContentsOf("/")
 textField.text = originalText
 }
 
 return true
 }
 
 */    /*
 func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
 {
 //Range.Lenth will greater than 0 if user is deleting text - Allow it to replce
 if range.length > 0
 {
 return true
 }
 
 //Dont allow empty strings
 if string == " "
 {
 return false
 }
 
 //Check for max length including the spacers we added
 if range.location >= 5
 {
 return false
 }
 
 var originalText = textField.text
 
 let replacementText = string.replacingOccurrences(of:" ", with: "")
 
 //Verify entered text is a numeric value
 let digits = NSCharacterSet.decimalDigits
 for char in replacementText.unicodeScalars
 {
 if !digits.longCharacterIsMember(char.value)
 {
 return false
 }
 }
 
 //Put / space after 2 digit
 if range.location == 2
 {
 originalText?.append(contentsOf: "/")
 //            originalText?.appendContentsOf("/")
 textField.text = originalText
 }
 
 return true
 }
 
 */



