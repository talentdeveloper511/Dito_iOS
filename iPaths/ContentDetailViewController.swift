 //
//  ContentDetailViewController.swift
//  iPaths
//
//  Created by Lebron on 3/29/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import UIKit
import Toast_Swift
import ImageSlideshow


class ContentDetailViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var productTable: UITableView!
        var alcoholDetailList:[ProductModel] = []
    var slideList: [SlideModel] = []
    
    @IBOutlet weak var imageSlide: ImageSlideshow!
    var cart_name :String!
  
    @IBOutlet weak var badge: UILabel!
    @IBOutlet weak var cartImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.loadSliderImages()
        loadSlide()
        loadProductData()
        imageSlide.contentScaleMode = .scaleAspectFill
        getCartNumber()
        self.loadProductData()
        cartImage.layer.cornerRadius = cartImage.layer.frame.height/2
        
        badge.layer.cornerRadius = badge.layer.frame.size.height/2
        badge.clipsToBounds = true
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadSliderImages(){
        ApiManager.sharedInstance().getSlideList(completion: { (arrClass, strError) in
            if let strError = strError {
                SVProgressHUD.showError(withStatus: strError)
                print("Load Data error")
            }else{
                SVProgressHUD.dismiss()
                if let list = arrClass?.list {
                    self.slideList = list
                    var inputSource:[InputSource] = []
                    for slide in self.slideList{
                        inputSource.append(AlamofireSource(urlString: slide.url!)!)
                    }
                    
                    self.imageSlide.setImageInputs(inputSource)
                }
            }
        })
    }
    
    func loadSlide(){
        
        var product_group: String = UserDefaults.standard.string(forKey: "alcoholgroup")!
        SVProgressHUD.show()
        ApiManager.sharedInstance().getSlides(product_group: product_group, completion: {(arrClass, strError) in
            if let strError = strError{
                SVProgressHUD.showError(withStatus: strError)
                print("load data error")
            }else{
                SVProgressHUD.dismiss()
                if let list = arrClass{
                    if (list.status)!{
                        self.slideList = list.list!
                        var inputSource:[InputSource] = []
                        for slide in self.slideList{
                            inputSource.append(AlamofireSource(urlString: slide.url!)!)
                        }
                        self.imageSlide.setImageInputs(inputSource)
                    }
                    else{
                        self.imageSlide.setImageInputs([
                            ImageSource(image: UIImage(named: "s1")!),
                            ImageSource(image: UIImage(named: "s2")!),
                            ImageSource(image: UIImage(named: "s3")!)
                            ])
                    }
                }
            }
            
            
        })
    }

    func getCartNumber(){
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
                        let cartNumber = "\(arrClass?.list?.count ?? 0)"
                        
                        print(cartNumber)
                        if (cartNumber == "0"){
                            self.badge.isHidden = true
                        }else{
                            self.badge.isHidden = false
                            self.badge.text = cartNumber

                        }
                        
                    }
                    
                })
            }
            
            else{
                self.badge.isHidden = true
                SVProgressHUD.dismiss()
            }
        }
            
        else {
            self.badge.isHidden = true
            SVProgressHUD.dismiss()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alcoholDetailList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ProductTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ProductTableViewCell
        let product = alcoholDetailList[indexPath.row]
        
        print(product.photo)
        if(product.photo != ""){
            cell?.productImage.af_setImage(withURL: URL(string:product.photo!)!)
        }
        
        else{
            cell?.productImage.image = UIImage(named: "bottle")
        }
        cell?.productImage.layer.cornerRadius = (cell?.productImage.frame.size.height)!/2
        cell?.productImage.clipsToBounds = true
        cell?.productImage.layer.borderColor = UIColor.yellow.cgColor
        cell?.productImage.layer.borderWidth = 2.0
        
        cell?.productName.text = product.Name
        cell?.productStyle.text = product.price! + "Lps"
        if(product.quantity == "0"){
            cell?.projectAmount.text = "Agotado"
            cell?.projectAmount.textColor = UIColor.yellow
            cell?.addproduct.isEnabled = false
        }
        else{
            cell?.projectAmount.text = ""
        }
        
        cell?.addproduct.tag = 100 + indexPath.row
        cell?.addproduct.addTarget(self, action: #selector(ContentDetailViewController.addCartTapped(_:)), for: .touchUpInside)
        return cell!
    }
    @objc func addCartTapped(_ sender: Any?) {
        SVProgressHUD.show(withStatus: "Please wait...")
        if let button = sender as? UIButton {
            let product_id = alcoholDetailList[(button.tag - 100)].id
            let user_id = UserDefaults.standard.string(forKey: "user_id")
            
            ApiManager.sharedInstance().getcartkey(user_id: user_id!, completion: {(baseModel, strErr) in
                if let strErr = strErr{
                    SVProgressHUD.showError(withStatus: strErr)
                }
                else{
                    let temp  = baseModel?.data
                    
                    
                    if(temp == "true"){
                        
                        self.cart_name = user_id! + "-" + "0"
                        
                        UserDefaults.standard.set(self.cart_name, forKey:"cart_name")
                        ApiManager.sharedInstance().addProductToCart(product_id: product_id!, user_id: user_id!, cart_name: self.cart_name!,completion: { (arrClass, strError) in
                            if let strError = strError {
                                SVProgressHUD.showError(withStatus: strError)
                            }else{
                                SVProgressHUD.dismiss()
                                button.isEnabled = false
                                
                                var style = ToastStyle()
                                // this is just one of many style options
                                style.messageColor = .white
                                // present the toast with the new style
                                self.view.window?.makeToast("Successfully added!", duration: 3.0, position: .bottom, style: style)
                                // toggle "tap to dismiss" functionality
                                ToastManager.shared.isTapToDismissEnabled = true
                                // toggle queueing behavior
                                ToastManager.shared.isQueueEnabled = true
                                
                                self.getCartNumber()
                            }
                        })

                    }
                    else{
                       
                        self.cart_name = user_id! + "-" + temp!
                        UserDefaults.standard.set(self.cart_name, forKey:"cart_name")
                        ApiManager.sharedInstance().addProductToCart(product_id: product_id!, user_id: user_id!, cart_name: self.cart_name!,completion: { (arrClass, strError) in
                            if let strError = strError {
                                SVProgressHUD.showError(withStatus: strError)
                            }else{
                                
                                let status = arrClass?.status
                                SVProgressHUD.dismiss()
                                button.isEnabled = false
                                
                                var style = ToastStyle()
                                // this is just one of many style options
                                style.messageColor = .white
                                // present the toast with the new style
                                if(status == true){
                                    self.view.window?.makeToast("Successfully added!", duration: 3.0, position: .bottom, style: style)
                                }
                                // toggle "tap to dismiss" functionality
                                ToastManager.shared.isTapToDismissEnabled = true
                                // toggle queueing behavior
                                ToastManager.shared.isQueueEnabled = true
                                self.getCartNumber()
                            }
                        })
                    }
                    
                    
                    
                }
            })
            
        }
    }
    

    @IBAction func backTo(_ sender: Any) {
        let vc = self.parent as! ContainerViewController
        let contentViewController = self.storyboard?.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
        vc.addChildViewController(contentViewController)
        vc.containerView.addSubview(contentViewController.view)
        
    }
    func loadProductData(){
        SVProgressHUD.show(withStatus: "Please wait...")
        let alcohol_type = UserDefaults.standard.string(forKey: "alcoholgroup")
       
        ApiManager.sharedInstance().getAlcoholDetailList(alcohol_type: alcohol_type!, completion: { (arrClass, strError) in
            if let strError = strError {
                SVProgressHUD.showError(withStatus: strError)
                print("Load Data error")
            }else{
                SVProgressHUD.dismiss()
                if let list = arrClass?.list {
                    self.alcoholDetailList = list
                    print(list)
                    self.productTable.reloadData()
                    
                }
            }
        })

    }
    
    @IBAction func goToMyCart(_ sender: Any) {
        let vc = self.parent as! ContainerViewController
        let myCartViewController = storyboard?.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
        vc.addChildViewController(myCartViewController)
        vc.containerView.addSubview(myCartViewController.view)
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
