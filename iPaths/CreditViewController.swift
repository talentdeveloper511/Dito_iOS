//
//  CreditViewController.swift
//  iPaths
//
//  Created by Lebron on 3/28/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import UIKit
import BetterSegmentedControl
import CCValidator

class CreditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var creditTable: UITableView!
    

    @IBOutlet weak var cardControl: BetterSegmentedControl!
    
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var digitView: UIView!
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var cardNumber: UITextField!
    
    @IBOutlet weak var cardName: UITextField!
    
    @IBOutlet weak var expDate: UITextField!
    @IBOutlet weak var cardCVC: UITextField!
    
    @IBOutlet weak var corpBtn: UIButton!
    
    var cards: [CardModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardControl.titles = ["Registradas","Digitar"]
        cardControl.titleFont = UIFont(name: "RimouskiLt", size: 25.0)!
        cardControl.selectedTitleFont = UIFont(name: "RimouskiRg",size: 25.0)!
        digitView.isHidden = true
        
        if((UserDefaults.standard.string(forKey: "user_type")?.count)! > 5){
            self.corpBtn.isHidden = false
        }
        else{
            self.corpBtn.isHidden = true
        }
        creditTable.allowsMultipleSelectionDuringEditing = false
        corpBtn.layer.cornerRadius = corpBtn.layer.frame.height/2
        loadCardData();
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let card_id = self.cards[indexPath.row].id ?? ""
            print(card_id)
            SVProgressHUD.show(withStatus: "Please wait...")
            ApiManager.sharedInstance().deleteCard(card_id: card_id, completion: {(baseModel, strError) in
                if let strError = strError
                {
                    SVProgressHUD.showError(withStatus: strError)
                    print("Load Data error")
                }
                else{
                    SVProgressHUD.dismiss()
                    self.cards.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            })
            
        }
    }
    
    @IBAction func goToCorp(_ sender: Any) {
        let vc = self.parent as! ContainerViewController
        let addCorpCreditViewController = storyboard?.instantiateViewController(withIdentifier: "AddCorpCreditViewController") as! AddCorpCreditViewController
        vc.addChildViewController(addCorpCreditViewController)
        vc.containerView.addSubview(addCorpCreditViewController.view)
        
    }
    
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        self.expDate.text = dateFormatter.string(from: sender.date)
        
        
    }
    
    func formValidation() -> Bool{
        let cardNumber = self.cardNumber.text
        return CCValidator.validate(creditCardNumber: cardNumber!)
        
    }
    
    @IBAction func textFieldEditing(_ sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(CheckOutViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    override func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    @IBAction func changeControl(_ sender: Any) {
        
        if(digitView.isHidden == true)
        {
            digitView.isHidden = false
            registerView.isHidden = true
        }
        else{
            digitView.isHidden = true
            registerView.isHidden = false
        }
    }
    
    @IBAction func addCard(_ sender: Any) {
        
        if(formValidation()){
            let cardName = self.cardName.text
            let cardNum = self.cardNumber.text
            let cardCVC = self.cardCVC.text
            var exp = self.expDate.text?.components(separatedBy: "/")
            
            let cardDate = exp![0] + "/" + exp![2]
            print(cardDate ?? "")
            let user_id = UserDefaults.standard.string(forKey: "user_id")
            SVProgressHUD.show(withStatus: "Please wait...")
            
            ApiManager.sharedInstance().addCreditCard(cardName: cardName!, cardNum: cardNum!, cardDate: cardDate, cardCVC: cardCVC!, user_id: user_id!, completion: {(arrClass, strError) in
                if let strError = strError {
                    SVProgressHUD.showError(withStatus: strError)
                    print("Load Data error")
                }else{
                    SVProgressHUD.dismiss()
                    let vc = self.parent as! ContainerViewController
                    let goMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "GoMenuViewController") as! GoMenuViewController
                    vc.addChildViewController(goMenuViewController)
                    vc.containerView.addSubview(goMenuViewController.view)
                    
                    
                }
            })
        }
        else{
            let alertController = UIAlertController(title: "Dito", message: "Card Error, Unknown Type!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }

        
        
    }
    func loadCardData(){
        SVProgressHUD.show(withStatus: "Please wait...")
        let user_id = UserDefaults.standard.string(forKey: "user_id")
        
        ApiManager.sharedInstance().getCardList(user_id: user_id!, completion: { (arrClass, strError) in
            if let strError = strError {
                SVProgressHUD.showError(withStatus: strError)
                print("Load Data error")
            }else{
                SVProgressHUD.dismiss()
                if let list = arrClass?.list {
                    self.cards = list
                    print(list)
                    self.creditTable.reloadData()
                    
                }
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CardTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CardTableViewCell
        let card = cards[indexPath.row]
        
        if(card.cardCVC == "credit"){
            self.corpBtn.isEnabled = false
        }
        
        cell?.number.text = "****_****_****_" + "\(card.cardNum?.suffix(4) ?? "")"
        cell?.name.text = card.cardName
        cell?.cvc.text = card.cardCVC
        cell?.date.text = card.cardDate
        
        cell?.name.font = UIFont(name: "RimouskiRg", size:25.0)
        cell?.number.font = UIFont(name: "RimouskiLt", size:22.0)
        cell?.cvc.font = UIFont(name: "RimouskiLt", size:22.0)
        cell?.date.font = UIFont(name: "RimouskiLt", size:22.0)
        return cell!
        
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
