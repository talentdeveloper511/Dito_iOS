//
//  HistoryViewController.swift
//  iPaths
//
//  Created by Lebron on 3/26/18.
//  Copyright © 2018 Marko Tahir. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var historyTitle: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    var histories: [OrderDriver] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTitle.font = UIFont(name: "RimouskiRg-Regular2", size: 39)
        
        loadHistoryData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return histories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "HistoryCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HistoryTableViewCell
        let history = histories[indexPath.row]
        cell?.timeLabel.text = "   " + history.endtime!
        cell?.timeLabel.font = UIFont(name: "RimouskiRg", size: 20)
        
        var finalAddr = ""
        var deliAddr = ""
        var pickAddr = ""
        cell?.deliveryLabel.text = history.pickaddress
        
        if(history.type == "Reg"){
            pickAddr = history.pickaddress!
            deliAddr = history.deliaddress!
            finalAddr = history.finaladdress!
            
        cell?.deliveryLabel.text = "de " + pickAddr + " a " + deliAddr + " a " + finalAddr
            
        }
        else{
            
            if(history.type == "Ida"){
                pickAddr = history.pickaddress!
                deliAddr = history.deliaddress!
                        cell?.deliveryLabel.text = "de " + pickAddr + " a " + deliAddr
            }
            if(history.type == "Product_Order"){
                pickAddr = "Almacén"
                deliAddr = history.deliaddress!
                cell?.deliveryLabel.text = "de " + pickAddr + " a " + deliAddr
            }
        }
        cell?.deliveryLabel.font = UIFont(name: "RimouskiRg", size: 18)
        
        return cell!
        
    }
    
    func loadHistoryData()
    {
        SVProgressHUD.show(withStatus: "Please Wait...")
        let user_id = UserDefaults.standard.string(forKey: "user_id")
        ApiManager.sharedInstance().getHistory(user_id: user_id!, completion: {(arrClass, strError) in
            if let strError = strError{
                SVProgressHUD.showError(withStatus: strError)
                
            }
            else{
                SVProgressHUD.dismiss()
                if let list = arrClass?.list {
                    self.histories = list
                    print(list)
                    self.tableView.reloadData()
                    
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let history = histories[indexPath.row]
        let order_id =  Int(history.id!)
        UserDefaults.standard.set(order_id, forKey: "viewdetail")
        UserDefaults.standard.set("history", forKey: "detail_type")
        let vc = self.parent as! ContainerViewController
        let orderDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailViewController") as! OrderDetailViewController
        vc.addChildViewController(orderDetailVC)
        vc.containerView.addSubview(orderDetailVC.view)

        
        
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
