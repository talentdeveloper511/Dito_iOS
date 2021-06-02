//
//  MainViewController.swift
//  iPaths
//
//  Created by Lebron on 3/25/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {


    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    override                                                                                                                                                       func viewDidLoad() {
        super.viewDidLoad()
        
//        for family: String in UIFont.familyNames
//        {
//            print("\(family)")
//            for names: String in UIFont.fontNames(forFamilyName: family)
//            {
//                print("== \(names)")
//            }
//        }
        mainTitle.font = UIFont(name: "RimouskiRg-Regular2", size: 28)
        subtitle.font = UIFont(name: "RimouskiRg", size:18 )
        // Do any additional setup after loading the view.
        
        loadInvoiceNumber()
        
        
    }
    
    func loadInvoiceNumber(){
        ApiManager.sharedInstance().getInvoiceNumber(completion: {(invoiceModel, strError) in
            if let strError = strError{
                print(strError)
            }else{
                
                if let invoice = invoiceModel{
                    if(invoice.invoice_num != nil){
                        UserDefaults.standard.set(invoice.invoice_num, forKey:"invoice_num")
                    }
                }
            }
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goToMedicine(_ sender: Any) {
        let alert = UIAlertController(title: "Dito", message: "This version will be coming soon.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
           alert.dismiss(animated: true, completion:  nil)
        }))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func goToTransport(_ sender: Any) {
        let alert = UIAlertController(title: "Dito", message: "This version will be coming soon.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            alert.dismiss(animated: true, completion:  nil)
        }))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func onGoToMesa(_ sender: Any) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "MensaViewController") as! MensaViewController
//        self.navigationController?.pushViewController(vc, animated: true)
        
        UserDefaults.standard.set("messenger_order",forKey: "product_order")
        let vc = self.parent as! ContainerViewController
              let mensaViewController = storyboard?.instantiateViewController(withIdentifier: "MensaViewController") as! MensaViewController
        vc.addChildViewController(mensaViewController)
        vc.containerView.addSubview(mensaViewController.view)
    
    }
    
    @IBAction func goToConveniencia(_ sender: Any) {
        
        UserDefaults.standard.set("product_order",forKey: "product_order")
        let vc = self.parent as! ContainerViewController
        let pickAddressViewController = storyboard?.instantiateViewController(withIdentifier: "PickAddressViewController") as! PickAddressViewController
        vc.addChildViewController(pickAddressViewController)
        vc.containerView.addSubview(pickAddressViewController.view)
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
