//
//  MensaViewController.swift
//  iPaths
//
//  Created by Lebron on 3/28/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import UIKit

class MensaViewController: UIViewController {

    @IBOutlet weak var mesaTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        mesaTitle.font = UIFont(name: "RimouskiRg-Regular2", size: 39)
        // Do any additional setup after loading the view.
        initData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initData(){
        UserDefaults.standard.set("", forKey: "pickAddr")
        UserDefaults.standard.set("",forKey: "delAddr")
        
        UserDefaults.standard.set("",forKey: "pickAddrReg")
        UserDefaults.standard.set("",forKey: "deliAddrReg")
        UserDefaults.standard.set("",forKey: "finalAddrReg")
        
        if(UserDefaults.standard.string(forKey: "idaPickLugar") != nil){
            UserDefaults.standard.set("", forKey: "idaPickLugar")
        }
        if(UserDefaults.standard.string(forKey: "idaDeliLugar") != nil){
            UserDefaults.standard.set("", forKey: "idaDeliLugar")
        }
        if(UserDefaults.standard.string(forKey: "regPickLugar") != nil){
            UserDefaults.standard.set("",forKey: "regPickLugar")
        }
        if(UserDefaults.standard.string(forKey: "regDeliLugar") != nil){
            UserDefaults.standard.set("",forKey: "regDeliLugar")
        }
        if(UserDefaults.standard.string(forKey: "regFinalLugar") != nil){
             UserDefaults.standard.set("",forKey: "regFinalLugar")
        }
        
    }
    @IBAction func backTo(_ sender: Any) {
        
        let vc = self.parent as! ContainerViewController
        let mainViewController = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        vc.addChildViewController(mainViewController)
        vc.containerView.addSubview(mainViewController.view)
        

    }
    
    @IBAction func goToMensaDetail2(_ sender: Any) {
        UserDefaults.standard.set("Bank", forKey:"messenger_service")
        let vc = self.parent as! ContainerViewController
        let bankViewController = storyboard?.instantiateViewController(withIdentifier: "ExpressViewController") as! ExpressViewController
        vc.addChildViewController(bankViewController)
        vc.containerView.addSubview(bankViewController.view)
    }
    @IBAction func goToMensaDetail(_ sender: Any) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "MensaDetailViewController") as! MensaDetailViewController
//        self.navigationController?.pushViewController(vc, animated: true)
                UserDefaults.standard.set("Messenger", forKey:"messenger_service")
        let vc = self.parent as! ContainerViewController
        let mensaDtailViewController = storyboard?.instantiateViewController(withIdentifier: "MensaDetailViewController") as! MensaDetailViewController
        vc.addChildViewController(mensaDtailViewController)
        vc.containerView.addSubview(mensaDtailViewController.view)
    
    }
    @IBAction func goToMensaDetail1(_ sender: Any) {
        
        UserDefaults.standard.set("Service", forKey:"messenger_service")
        let vc = self.parent as! ContainerViewController
        let bankViewController = storyboard?.instantiateViewController(withIdentifier: "ExpressViewController") as! ExpressViewController
        vc.addChildViewController(bankViewController)
        vc.containerView.addSubview(bankViewController.view)
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
