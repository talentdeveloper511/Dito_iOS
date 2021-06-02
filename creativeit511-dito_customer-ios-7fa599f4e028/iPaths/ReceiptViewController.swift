//
//  ReceiptViewController.swift
//  iPaths
//
//  Created by Marko Dreher on 9/13/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import UIKit

class ReceiptViewController: UIViewController {

    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var frontImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let orderId = UserDefaults.standard.string(forKey: "order_id_receipt") 
        loadImage(orderID: orderId! )
        if let frontUrl = UserDefaults.standard.string(forKey: "receiptFront"){
            frontImage.af_setImage(withURL: URL(string: frontUrl)!)
        }
        
        if let backURL = UserDefaults.standard.string(forKey:"receiptBack"){
            backImage.af_setImage(withURL: URL(string: backURL)!)
        }
        // Do any additional setup after loading the view.
    }
    
    func loadImage(orderID: String){
        ApiManager.sharedInstance().getReceiptImages(order_id: orderID, completion: {(arrClass, strError)  in
            if let strError = strError{
                print(strError)
            }else{
                if let receipt = arrClass{
                    if(receipt.responseStatus!){
                        self.frontImage.af_setImage(withURL: URL(string: receipt.receiptFront!)!)
                        self.backImage.af_setImage(withURL: URL(string: receipt.receiptBack!)!)
                    }else{
                        let alert = UIAlertController(title: "Dito", message: "Este pedido no tiene ninguna imagen de recibo.", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "¡Sí!", style: .default, handler: { action in
                            alert.dismiss(animated: true, completion:  nil)
                        }))
                        
                        self.present(alert, animated: true)
                    }
                }
            }
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
