//
//  MyCartViewController.swift
//  iPaths
//
//  Created by Lebron on 3/29/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import UIKit

class MyCartViewController: UIViewController , UITableViewDelegate, UITableViewDataSource  {

    
    
    var cartList:[CartModel] = []
    var order_amount:String?
    
    @IBOutlet weak var total_price: UILabel!
    
    @IBOutlet weak var cartTable: UITableView!
    @IBOutlet weak var CartTitle: UILabel!
    @IBOutlet weak var btnCheckOut: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       
//        CartTitle.font = UIFont(name: "RimouskiRg-Regular2", size: 39)
            CartTitle.font = UIFont(name: "RimouskiRg", size: 39)
        btnCheckOut.titleLabel?.font = UIFont(name: "RimouskiRg", size: 19)
        cartTable.allowsMultipleSelectionDuringEditing = false
         loadCartData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadCartData(){
        SVProgressHUD.show(withStatus: "Please wait...")
        let cart_name = UserDefaults.standard.string(forKey: "cart_name")
        
        if cart_name != nil{
            if((cart_name?.count)! > 2){
                ApiManager.sharedInstance().getCartData(cart_name: cart_name!, completion: { (arrClass, strError) in
                    if let strError = strError {
                        SVProgressHUD.showError(withStatus: strError)
                        print("Load Data error")
                    }else{
                        SVProgressHUD.dismiss()
                        if let list = arrClass?.list {
                            self.cartList = list
                            print(list)
                            self.cartTable.reloadData()
                            
                            self.setTotalPrice()
                            
                        }
                    }
                })
 
                
            }
            else{
                self.total_price.text = "0"
            }
            SVProgressHUD.dismiss()

        }
        else{
            SVProgressHUD.dismiss()
            
            self.total_price.text = "0"
        }
        

    }
    
    func setTotalPrice(){
        
        var amount = 0.0
        for cart in self.cartList
        {
            let quantity = Double(cart.quantity!)
            print(quantity)
            print(cart.price)
            
            var str_temp = cart.price?.removingCharactersInSet(CharacterSet(charactersIn: ","))
            var arr_str = str_temp?.components(separatedBy: ".")
            let real_price = arr_str![0]
            let price = (real_price as! NSString).doubleValue
            print(price)
            let temp = quantity! * price
            amount += temp
            
        }
        print(amount)
        self.total_price.text = "\(amount)"
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MyCartCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CartTableViewCell
        let cart = cartList[indexPath.row]
        if(cart.photo != ""){
        cell?.cartImage.af_setImage(withURL: URL(string: cart.photo!)!)
        }
        else{
            cell?.cartImage.image = UIImage(named: "bottle")
        }
        cell?.cartImage.clipsToBounds = true
        cell?.cartImage.layer.cornerRadius = (cell?.cartImage.layer.frame.size.height)!/2
        cell?.cartImage.layer.borderColor = UIColor.yellow.cgColor
        cell?.cartImage.layer.borderWidth = 2.0
        cell?.cartName.text = cart.Name
        cell?.cartAmount.text = cart.price! + "Lps"
        cell?.cartQuantity.text = cart.quantity
        cell?.increaseBtn.tag = 100 + indexPath.row
        cell?.increaseBtn.addTarget(self,  action:#selector(MyCartViewController.increaseTapped(_:)) , for: .touchUpInside)
        
        cell?.decreaseBtn.tag = 101 + indexPath.row
        cell?.decreaseBtn.addTarget(self,  action:#selector(MyCartViewController.decreaseTapped(_:)) , for: .touchUpInside)

        return cell!
    }
    @IBAction func backTo(_ sender: Any) {
        let vc = self.parent as! ContainerViewController
        let contentDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "ContentDetailViewController") as! ContentDetailViewController
        vc.addChildViewController(contentDetailViewController)
        vc.containerView.addSubview(contentDetailViewController.view)
    }
    @objc func increaseTapped(_ sender: Any?) {
        SVProgressHUD.show(withStatus: "Please wait...")
        if let button = sender as? UIButton {
            let cart_id = cartList[button.tag - 100].cart_id
            let quantity = Int(cartList[button.tag - 100].quantity!)
            
            let temp = "\(String(describing: quantity! + 1))"
            
            
            ApiManager.sharedInstance().increaseProductQuantity(cart_id: cart_id!, cart_quantity: "\(quantity! + 1)", completion:{(baseModel, strError) in
                if let strError = strError{
                    SVProgressHUD.showError(withStatus: strError)
                    print("Load Data error")
                }
                else{
                    if let result = baseModel{
                        SVProgressHUD.dismiss()
                        if(!result.status!){
                            let alertController = UIAlertController(title: "Dito", message: "Can't Order more much because this item limited", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alertController, animated: true)
                        }
                        else{
                            self.cartList[button.tag - 100].quantity = temp
                            self.cartTable.reloadData()
                            self.setTotalPrice()

                        }
                        
                    }
                }
                
                
            })

        }
    }
    
    @objc func decreaseTapped(_ sender: Any?) {
        SVProgressHUD.show(withStatus: "Please wait...")
        if let button = sender as? UIButton {
            let cart_id = cartList[button.tag - 101].cart_id
            let quantity = Int(cartList[button.tag - 101].quantity!)
            let temp = "\(String(describing: quantity! - 1))"
            cartList[button.tag - 101].quantity = temp
            if(quantity! > 0){
                ApiManager.sharedInstance().increaseProductQuantity(cart_id: cart_id!, cart_quantity: "\(quantity! - 1)", completion:{(baseModel, strError) in
                    if let strError = strError{
                        SVProgressHUD.showError(withStatus: strError)
                        print("Load Data error")
                    }
                    else{
                        SVProgressHUD.dismiss()
                        self.cartTable.reloadData()
                        self.setTotalPrice()
                    }
                    
                    
                })
            }

            
        }
    }
 
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
                if editingStyle == .delete {
                                let cart_id = self.cartList[indexPath.row].cart_id ?? ""
                                print(cart_id)
                                SVProgressHUD.show(withStatus: "Please wait...")
                                ApiManager.sharedInstance().deleteCart(cart_id: cart_id, completion: {(baseModel, strError) in
                                    if let strError = strError
                                    {
                                        SVProgressHUD.showError(withStatus: strError)
                                        print("Load Data error")
                                    }
                                    else{
                                        SVProgressHUD.dismiss()
                                        self.cartList.remove(at: indexPath.row)
                                        tableView.deleteRows(at: [indexPath], with: .fade)
                                    }
                                })
         
                }
    }


    @IBAction func checkOut(_ sender: Any) {
        
        if(cartList.count > 0){
            var amount = 0.0
            for cart in cartList
            {
                let quantity = Double(cart.quantity!)
                print(quantity)
                print(cart.price)
                
                var str_temp = cart.price?.removingCharactersInSet(CharacterSet(charactersIn: ","))
                var arr_str = str_temp?.components(separatedBy: ".")
                let real_price = arr_str![0]
                let price = (real_price as! NSString).doubleValue
                print(price)
                let temp = quantity! * price
                amount += temp
            }
            
            self.order_amount =  String(format: "%.0f", amount)
            UserDefaults.standard.set(self.order_amount, forKey:"order_amount")
            UserDefaults.standard.set("Product_Order", forKey: "order_type")
            let vc = self.parent as! ContainerViewController
            let checkoutViewController = storyboard?.instantiateViewController(withIdentifier: "CheckOutViewController") as! CheckOutViewController
            vc.addChildViewController(checkoutViewController)
            vc.containerView.addSubview(checkoutViewController.view)
        }
        
        else{
            let alertController = UIAlertController(title: "Dito", message: "Warning: Cart Empty!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true)
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
