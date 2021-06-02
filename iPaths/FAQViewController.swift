//
//  FAQViewController.swift
//  iPaths
//
//  Created by Lebron on 3/26/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import UIKit
import BetterSegmentedControl

class FAQViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var faqtitle: UILabel!

    @IBOutlet weak var faqType: BetterSegmentedControl!
    //    @IBOutlet weak var faqWebview: UIWebView!
    
    @IBOutlet weak var tableView: UITableView!
    var faqList:[FAQModel] = []
    var tempList:[FAQModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        faqtitle.font = UIFont(name: "RimouskiRg-Regular2", size: 39)
        faqType.titles = ["GENERAL", "Servicios", "Pagos", "Empresas"]
        faqType.titleFont = UIFont(name: "RimouskiLt", size: 18.0)!
        faqType.selectedTitleFont = UIFont(name: "RimouskiRg", size: 19.0)!
        loadFAQ()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadFAQ(){
        SVProgressHUD.show(withStatus: "Please Wait..."); ApiManager.sharedInstance().getFAQ(completion: {(arrClass, strErr) in
            if let strErr = strErr {
                SVProgressHUD.showError(withStatus: strErr)
            }
            else{
                SVProgressHUD.dismiss()
                if let list = arrClass?.list{
                    self.tempList = list
                    
                    for item in self.tempList {
                        if(item.group_name == "Dudas Generales"){
                            self.faqList.append(item)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        })
    }

    @IBAction func faqChange(_ sender: Any) {
        faqList = []
        var type = ""
        switch faqType.index {
        case 0:
            type = "Dudas Generales"
            break
        case 1:
            type = "Servicios"
            break
        case 2:
            type = "Pagos"
            break
        case 3:
            type = "Empresas"
            break
            
        default:
            type = "Dudas Generales"
            break
        }
        for item in self.tempList {
            if(item.group_name == type){
                self.faqList.append(item)
            }
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQTableViewCell") as! FAQTableViewCell
        let faq = self.faqList[indexPath.row]
        
        cell.answerText.text = faq.answer
        cell.questionLabel.text = faq.question
        
        return cell
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
