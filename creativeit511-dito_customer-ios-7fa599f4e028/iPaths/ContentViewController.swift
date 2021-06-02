//
//  ContentViewController.swift
//  iPaths
//
//  Created by Lebron on 3/29/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import UIKit
import AlamofireImage
import ImageSlideshow

class ContentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var alcoholList:[ImageModel] = []
    var slideList: [SlideModel] = []

    @IBOutlet weak var cartImage: UIImageView!
    
    @IBOutlet weak var slideShow: ImageSlideshow!
    @IBOutlet weak var badge: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var alcoholGroup: UITableView!
    @IBOutlet weak var sortBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        sortBtn.layer.cornerRadius = 2
//        slideShow.setImageInputs([
//            ImageSource(image: UIImage(named: "s1")!),
//            ImageSource(image: UIImage(named: "s2")!),
//            ImageSource(image: UIImage(named: "s3")!)
//            ])
        
//        loadSliderImages()
        loadSlide()
        slideShow.contentScaleMode = .scaleAspectFill
        self.loadData()
        self.getCartNumber()
        self.cartImage.layer.cornerRadius = cartImage.layer.frame.height/2
        productTitle.font = UIFont(name: "RimouskiRg-Regular2", size: 32)
        badge.layer.cornerRadius = badge.layer.frame.size.height/2
        badge.clipsToBounds = true
        // Do any additional setup after loading the view.
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
                    self.slideShow.setImageInputs(inputSource)
                }
            }
        })
    }
    
    func loadSlide(){
        SVProgressHUD.show()
        ApiManager.sharedInstance().getSlides(product_group: "Main", completion: {(arrClass, strError) in
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
                        self.slideShow.setImageInputs(inputSource)
                    }
                    else{
                        self.slideShow.setImageInputs([
                            ImageSource(image: UIImage(named: "s1")!),
                            ImageSource(image: UIImage(named: "s2")!),
                            ImageSource(image: UIImage(named: "s3")!)
                            ])
                    }
                }
            }
            
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backTo(_ sender: Any) {
        let vc = self.parent as! ContainerViewController
        let pickAddressViewController = storyboard?.instantiateViewController(withIdentifier: "PickAddressViewController") as! PickAddressViewController
        vc.addChildViewController(pickAddressViewController)
        vc.containerView.addSubview(pickAddressViewController.view)
    }
    
    func getCartNumber(){
        SVProgressHUD.show(withStatus: "Please wait...")
        let cart_name = UserDefaults.standard.string(forKey: "cart_name") ?? ""
        print(UserDefaults.standard.string(forKey: "cart_name"))
        if cart_name != nil{
            if((cart_name.count) > 2){
                ApiManager.sharedInstance().getCartData(cart_name: cart_name, completion: { (arrClass, strError) in
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

    
    @IBAction func goToMyCart(_ sender: Any) {
        let vc = self.parent as! ContainerViewController
        let myCartViewController = storyboard?.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
        vc.addChildViewController(myCartViewController)
        vc.containerView.addSubview(myCartViewController.view)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alcoholList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlcoholTableViewCell") as! AlcoholTableViewCell
        let alcohol = self.alcoholList[indexPath.row]
        print(alcohol.photo)
        if(!(alcohol.photo?.isEmpty)!) {
            cell.alcoholType.af_setImage(withURL: URL(string: alcohol.photo!)!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alcoholgroup = self.alcoholList[indexPath.row]
        UserDefaults.standard.set(alcoholgroup.name, forKey: "alcoholgroup")
        
        let vc = self.parent as! ContainerViewController
        let contentDetailViewController = storyboard?.instantiateViewController(withIdentifier: "ContentDetailViewController") as! ContentDetailViewController
        vc.addChildViewController(contentDetailViewController)
        vc.containerView.addSubview(contentDetailViewController.view)
        
    }
    
    func loadData(){
        SVProgressHUD.show(withStatus: "Please wait...")
        ApiManager.sharedInstance().getAlcoholList(completion: { (arrClass, strError) in
            if let strError = strError {
                SVProgressHUD.showError(withStatus: strError)
                print("Load Data error")
            }else{
                SVProgressHUD.dismiss()
                if let list = arrClass?.list {
                    
                    for alcohol in list{
                        if(alcohol.name != "Main"){
                            self.alcoholList.append(alcohol)
                        }    
                    }
                    self.alcoholGroup.reloadData()
                    
                }
            }
        })

    }
    
    
    
    @IBAction func sort(_ sender: Any) {
        
        alcoholList.sort { (left, right) -> Bool in
            return left.name?.compare(right.name!) == ComparisonResult.orderedAscending
        }
        
        self.alcoholGroup.reloadData()
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
