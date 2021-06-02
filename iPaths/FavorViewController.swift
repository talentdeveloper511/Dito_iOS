//
//  FavorViewController.swift
//  iPaths
//
//  Created by Lebron on 3/26/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import UIKit

class FavorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var FavoriteTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var favorties :[Addr] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FavoriteTitle.font = UIFont(name: "RimouskiRg-Regular2", size: 39)
        self.tableView.allowsMultipleSelectionDuringEditing = false
        loadFavoriteData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "FavoriteCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FavoriteTableViewCell
        let favorite = favorties[indexPath.row]
        
        cell?.FavDes.text = favorite.addr
        cell?.FavDes.font = UIFont(name: "RimouskiSb-Regular", size: 20)
        cell?.FavTitle.text = favorite.name
        cell?.FavTitle.font = UIFont(name: "RimouskiSb-Regular", size: 33)
        cell?.logoImage.image = UIImage(named:"sidelogo")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let addr_id = self.favorties[indexPath.row].id ?? ""
            print(addr_id)
            SVProgressHUD.show(withStatus: "Please wait...")
            ApiManager.sharedInstance().deleteAddr(addr_id: addr_id, completion: {(baseModel, strError) in
                if let strError = strError
                {
                    SVProgressHUD.showError(withStatus: strError)
                    print("Load Data error")
                }
                else{
                    SVProgressHUD.dismiss()
                    self.favorties.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            })
            
        }
    }
    
    func loadFavoriteData(){
        
        SVProgressHUD.show(withStatus: "Please Wait...")
        let user_id = UserDefaults.standard.string(forKey: "user_id")
        ApiManager.sharedInstance().getAddrList(user_id: user_id!, completion: {(arrClass, strErr) in
            if let strErr = strErr{
                SVProgressHUD.showError(withStatus: strErr)
            }
            else{
                SVProgressHUD.dismiss()
                if let list = arrClass?.list {
                    self.favorties = list
                    print(list)
                    self.tableView.reloadData()
                    
                }
            }
        })
    }
    @IBAction func addAddr(_ sender: Any) {
        let vc = self.parent as! ContainerViewController
        let addAddrViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddAddrViewController") as! AddAddrViewController
        vc.addChildViewController(addAddrViewController)
        vc.containerView.addSubview(addAddrViewController.view)
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
