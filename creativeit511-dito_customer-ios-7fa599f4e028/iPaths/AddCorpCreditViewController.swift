//
//  AddCorpCreditViewController.swift
//  iPaths
//
//  Created by Marko Dreher on 7/2/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import UIKit
import MessageUI

class AddCorpCreditViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var rubroText: UITextField!
    @IBOutlet weak var cantidadText: UITextField!
    
    @IBOutlet weak var monteText: UITextField!
    
    @IBOutlet weak var usariosText: UITextField!
    @IBOutlet weak var oficinaText: UITextField!
    
    var message: String  = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sign(_ sender: Any) {
        message = "Rubro De Empresa:" + rubroText.text! + "Cantidad de Envios:" + cantidadText.text! + "Monto de Credito:" + monteText.text! +
            "Numero de Oficina" + oficinaText.text! +
            "Numero de Usarios" + usariosText.text!
        
        sendEmail()
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
            mail.setToRecipients(["appdito@ditoexpress.com"])
            mail.setMessageBody(message, isHTML: false)
            mail.setSubject("Credit Approve Request")
            
            present(mail, animated: true)
        } else {
            // show failure alert
            print("failed")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        
        ApiManager.sharedInstance().addCreditCard(cardName: UserDefaults.standard.string(forKey: "user_name")!, cardNum: UserDefaults.standard.string(forKey: "user_phone")!, cardDate: result, cardCVC: "credit", user_id: UserDefaults.standard.string(forKey: "user_id")!, completion:
            {(arrClass, strErr) in
                if let strErr = strErr{
                    SVProgressHUD.showError(withStatus: strErr)
                }
                else{
                    SVProgressHUD.dismiss()
                    
                    let vc = self.parent as! ContainerViewController
                    let thanksViewController = self.storyboard?.instantiateViewController(withIdentifier: "ThanksViewController") as! ThanksViewController
                    vc.addChildViewController(thanksViewController)
                    vc.containerView.addSubview(thanksViewController.view)
                }
        })
 
    }
    
    
    @IBAction func goToBack(_ sender: Any) {
        
        let vc = self.parent as! ContainerViewController
        let mainViewController = storyboard?.instantiateViewController(withIdentifier: "CreditViewController") as! CreditViewController
        vc.addChildViewController(mainViewController)
        vc.containerView.addSubview(mainViewController.view)
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
