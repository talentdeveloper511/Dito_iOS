//
//  ApiManager.swift
//  iPaths
//
//  Created by Jackson on 5/10/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class ApiManager{
    
    static var _webService: ApiManager? = nil;
    var header: [String: String]?
    
    static func sharedInstance() -> ApiManager {
        if(_webService == nil) {
            _webService = ApiManager()
        }
        
        return _webService!
    }
    
    
    init()
    {
        
    }
    private func getErrorString(_ error: Data) -> String {
        do {
            let dicError = try JSONSerialization.jsonObject(with: error, options: []) as! [String: Any]
            if let errStr = dicError[Constants.Server.RESPONSE_MESSAGE] {
                return errStr as! String
            }else{
                return "No data to display"
            }
        } catch let error {
            return error.localizedDescription
        }
    }
    

    func login(email: String, password: String, completion: @escaping (UserInfo?, String?) -> Void){
        let parameters: Parameters = ["user_email": email, "user_password":password]
        let url = "\(Constants.Server.URL)login_user/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<UserInfo>) in
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    
    func getCompanyInfo(id: String, completion: @escaping (UserInfo?, String?) -> Void){
        let parameters: Parameters = ["user_id": id]
        let url = "\(Constants.Server.URL)getcompanyinfo/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<UserInfo>) in
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    func addUserPhoto(image:UIImage, imageName:String, completion:@escaping (UrlModel?, String?) -> Void) {
        
        let urlString = "\(Constants.Server.URL)uploadImage/"
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            if let imageData = UIImageJPEGRepresentation(image, 0) {
                multipartFormData.append(imageData, withName: "photo", fileName: imageName, mimeType: "image/png")
            }}, to: urlString, method: .post, headers: [:],
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseObject() { (response: DataResponse<UrlModel>) in
                            if let data = response.data {
                                let json = String(data: data, encoding: String.Encoding.utf8)
                                print("Failure Response: \(json ?? "")")
                            }
                            switch response.result {
                            case .success(let objLead):
                                completion(objLead, nil)
                            case .failure(_):
                                completion(nil, self.getErrorString(response.data!))
                            }
                        }
                    case .failure(let encodingError):
                        print("error:\(encodingError)")
                    }
        })
    }
    

    func signup_company(name: String, password: String, phone_num: String, email: String, office_num: String, business: String, month_ship:String, user_type: String, completion: @escaping (UserInfo?, String?) -> Void){
        let parameters: Parameters = ["user_name": name,  "user_email": email, "user_password":password, "user_office_num": office_num, "user_business": business, "user_month_ship": month_ship, "user_type": user_type, "user_phone_num": phone_num]
        let url = "\(Constants.Server.URL)signup_company/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<UserInfo>) in
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    func signup_user(name: String, password: String, phone_num: String, email: String, photo: String, user_type: String, completion: @escaping (UserInfo?, String?) -> Void){
        let parameters: Parameters = ["user_name": name,  "user_email": email, "user_password":password, "user_photo": photo, "user_type": user_type, "user_phone_num": phone_num]
        let url = "\(Constants.Server.URL)signup_user/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<UserInfo>) in
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Failure Response: \(json ?? "")")
                }
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    func update_user(user_id: String, name: String, password: String, phone_num: String, email: String, photo: String, completion: @escaping (UserInfo?, String?) -> Void){
        let parameters: Parameters = ["user_id": user_id, "user_name": name,  "user_email": email, "user_password":password, "user_photo": photo,  "user_phone_num": phone_num]
        let url = "\(Constants.Server.URL)update_user/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<UserInfo>) in
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    func update_company(user_id: String, name: String, password: String, phone_num: String, email: String, office_num: String, business: String, month_ship: String, current: String, completion: @escaping (UserInfo?, String?) -> Void){
        let parameters: Parameters = ["user_id": user_id, "user_name": name,  "user_email": email, "user_password":password, "user_office_num": office_num,  "user_phone_num": phone_num, "user_business": business, "user_month_ship": month_ship, "user_current": current]
        let url = "\(Constants.Server.URL)update_company/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<UserInfo>) in
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }

    
    
    func verifyCode(phone:String, completion: @escaping (BaseModel?, String?) -> Void){
        let parameters: Parameters = ["phone": phone]
        let url = "\(Constants.Server.URL)verifyPhone/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<BaseModel>) in
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Failure Response: \(json ?? "")")
                }
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    func forgotPassword(email:String, completion: @escaping (BaseModel?, String?) -> Void){
        let parameters: Parameters = ["email": email]
        let url = "\(Constants.Server.URL)forgotpassword/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<BaseModel>) in
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    func getAlcoholList (completion: @escaping (AlcoholList?, String?) -> Void){
        
        Alamofire.request("\(Constants.Server.URL)getalcohollist/")
            .validate()
            .responseObject() { (response: DataResponse<AlcoholList>) in
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Failure Response: \(json ?? "")")
                }
                
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    func getAlcoholDetailList(alcohol_type: String, completion: @escaping (AlcoholDetailList?, String?) -> Void){
        let parameters: Parameters = ["product_group_name": alcohol_type]
        let url = "\(Constants.Server.URL)getalcoholdetaillist/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<AlcoholDetailList>) in
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    func addProductToCart(product_id: String, user_id: String, cart_name: String, completion: @escaping (BaseModel?, String?) -> Void){
        let parameters: Parameters = ["product_id": product_id, "user_id": user_id, "cart_name": cart_name]
        let url = "\(Constants.Server.URL)addproducttocart/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<BaseModel>) in
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    func getcartkey(user_id:String ,completion: @escaping (BaseModel?, String?) -> Void){
        let parameters: Parameters = ["user_id": user_id]
        let url = "\(Constants.Server.URL)getcartkey/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<BaseModel>) in
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Failure Response: \(json ?? "")")
                }
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    func getCartData(cart_name: String, completion: @escaping (CartList?, String?) -> Void){
        let parameters: Parameters = ["cart_name": cart_name]
        let url = "\(Constants.Server.URL)displaycart/"
            Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<CartList>) in
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Failure Response: \(json ?? "")")
                }
            switch response.result {
            case .success(let objLead):
            completion(objLead, nil)
            case .failure(_):
            completion(nil, self.getErrorString(response.data!))
            }
        }
    }
    
    func increaseProductQuantity(cart_id: String, cart_quantity: String, completion: @escaping (BaseModel?, String?) -> Void){
        let parameters: Parameters = ["cart_id": cart_id, "cart_quantity": cart_quantity]
        let url = "\(Constants.Server.URL)increaseProductQuantity/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
        .validate()
        .responseObject() { (response: DataResponse<BaseModel>) in
        switch response.result {
        case .success(let objLead):
        completion(objLead, nil)
        case .failure(_):
        completion(nil, self.getErrorString(response.data!))
        }
        }
    }
    
    
    func deleteCart(cart_id: String, completion: @escaping (BaseModel?, String?) -> Void){
        let parameters: Parameters = ["cart_id": cart_id]
        let url = "\(Constants.Server.URL)deletecart/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<BaseModel>) in
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    func deleteAddr(addr_id: String, completion: @escaping (BaseModel?, String?) -> Void){
        let parameters: Parameters = ["addr_id": addr_id]
        let url = "\(Constants.Server.URL)deletefavaddr/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<BaseModel>) in
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    func deleteCard(card_id: String, completion: @escaping (BaseModel?, String?) -> Void){
        let parameters: Parameters = ["card_id": card_id]
        let url = "\(Constants.Server.URL)deleteCreditCard/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<BaseModel>) in
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    func getBankList (completion: @escaping (BankList?, String?) -> Void){
        
        Alamofire.request("\(Constants.Server.URL)getbanklist/")
            .validate()
            .responseObject() { (response: DataResponse<BankList>) in
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    func getServiceList (completion: @escaping (ServiceList?, String?) -> Void){
        
        Alamofire.request("\(Constants.Server.URL)getservicelist/")
            .validate()
            .responseObject() { (response: DataResponse<ServiceList>) in
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    func getDistancePrice(completion: @escaping (DistanceModel?, String?) -> Void){
        
        let url = "\(Constants.Server.URL)getdistanceprice/"
        Alamofire.request(url)
            .validate()
            .responseObject() { (response: DataResponse<DistanceModel>) in
                
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Failure Response: \(json ?? "")")
                }
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    func getCityList(completion: @escaping (CityList?, String?) -> Void){
        
        let url = "\(Constants.Server.URL)get_cities/"
        Alamofire.request(url)
            .validate()
            .responseObject() { (response: DataResponse<CityList>) in
                
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Failure Response: \(json ?? "")")
                }
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    func getTimeList(completion: @escaping (TimeList?, String?) -> Void){
        
        let url = "\(Constants.Server.URL)get_flat_fees/"
        Alamofire.request(url)
            .validate()
            .responseObject() { (response: DataResponse<TimeList>) in
                
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Failure Response: \(json ?? "")")
                }
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    func getSlideList(completion: @escaping (SlideList?, String?) -> Void){
        
        let url = "\(Constants.Server.URL)get_slider_images/"
        Alamofire.request(url)
            .validate()
            .responseObject() { (response: DataResponse<SlideList>) in
                
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Failure Response: \(json ?? "")")
                }
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    
    func getSlides(product_group:String, completion: @escaping (SlideList?, String?) -> Void){
        let parameters: Parameters = ["product_group": product_group]
        let url = "\(Constants.Server.URL)get_slider_image/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<SlideList>) in
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Failure Response: \(json ?? "")")
                }
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    func addCreditCard(cardName: String, cardNum: String, cardDate: String, cardCVC: String, user_id: String, completion: @escaping (BaseModel?, String?) -> Void){
        let parameters: Parameters = ["name": cardName, "card_num": cardNum, "date": cardDate, "cvc": cardCVC, "user_id": user_id]
        
        let url = "\(Constants.Server.URL)add_credit_card/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<BaseModel>) in
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    func addFavAddr(Address: String, longtitude: String, latitude: String, name: String,  user_id: String, completion: @escaping (BaseModel?, String?) -> Void){
        let parameters: Parameters = ["favorite_addr": Address, "longtitude": longtitude, "latitude": latitude, "name": name, "user_id": user_id]
        
        let url = "\(Constants.Server.URL)add_fav_addr/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<BaseModel>) in
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    func getCardList(user_id: String, completion: @escaping (CardList?, String?) -> Void){
        let parameters: Parameters = ["user_id": user_id]
        let url = "\(Constants.Server.URL)getCreditCards/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<CardList>) in
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    func getAddrList(user_id: String, completion: @escaping (AddrList?, String?) -> Void){
        let parameters: Parameters = ["user_id": user_id]
        let url = "\(Constants.Server.URL)getFavAddrs/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<AddrList>) in
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    func addOrderService(order_user_id: String, order_start_time: String, order_pick_address: String, order_type: String, order_amount: String, order_pick_lat: String, order_pick_long: String, email: String, order_contact_name: String, order_contact_num: String, completion: @escaping (BaseModel?, String?) -> Void){
        let parameters: Parameters = ["order_user_id": order_user_id,  "order_start_time": order_start_time, "order_pick_address":order_pick_address, "order_type": order_type, "order_amount": order_amount, "order_pick_lat": order_pick_lat, "order_pick_long": order_pick_long, "email": email, "order_contact_name": order_contact_name, "order_contact_num": order_contact_num]
        let url = "\(Constants.Server.URL)add_order_service/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<BaseModel>) in
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    func addOrderProduct(order_user_id: String, order_start_time: String, order_delivery_address: String, order_type: String, order_amount: String, order_delivery_lat: String, order_delivery_long: String, cart_name: String, email: String,  order_contact_name: String, order_contact_num: String,  completion: @escaping (BaseModel?, String?) -> Void){
        let parameters: Parameters = ["order_user_id": order_user_id,  "order_start_time": order_start_time, "order_delivery_address":order_delivery_address, "order_type": order_type, "order_amount": order_amount, "order_delivery_lat": order_delivery_lat, "order_delivery_long": order_delivery_long, "cart_name": cart_name, "email": email, "order_contact_name": order_contact_name, "order_contact_num": order_contact_num]
        let url = "\(Constants.Server.URL)add_order_product/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            
            .responseObject() { (response: DataResponse<BaseModel>) in
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Failure Response: \(json ?? "")")
                }
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    func addOrderIda(order_user_id: String, order_start_time: String, order_pick_address:String,  order_delivery_address: String, order_type: String, order_amount: String, order_pick_lat: String, order_pick_long: String, order_delivery_lat: String, order_delivery_long: String, order_pick_lugar: String, order_deli_lugar: String, order_contact_name: String, order_contact_num: String, email: String, completion: @escaping (BaseModel?, String?) -> Void){
        let parameters: Parameters = ["order_user_id": order_user_id,  "order_start_time": order_start_time, "order_pick_address": order_pick_address,  "order_delivery_address":order_delivery_address, "order_type": order_type, "order_amount": order_amount,"order_pick_lat": order_pick_lat, "order_pick_long": order_pick_long, "order_delivery_lat": order_delivery_lat, "order_delivery_long": order_delivery_long, "order_pick_lugar": order_pick_lugar, "order_deli_lugar": order_deli_lugar, "order_contact_name": order_contact_name, "order_contact_num": order_contact_num, "email": email]
        let url = "\(Constants.Server.URL)add_order_ida/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<BaseModel>) in
                
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Failure Response: \(json ?? "")")
                }
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    func addOrderReg(order_user_id: String, order_start_time: String, order_pick_address:String,  order_delivery_address: String, order_mid_address: String, order_type: String, order_amount: String, order_pick_lat: String, order_pick_long: String, order_delivery_lat: String, order_delivery_long: String, order_mid_lat: String, order_mid_long: String, order_pick_lugar: String, order_deli_lugar: String, order_final_lugar: String, order_contact_name: String, order_contact_num: String, email: String, completion: @escaping (BaseModel?, String?) -> Void){
        let parameters: Parameters = ["order_user_id": order_user_id,  "order_start_time": order_start_time, "order_pick_address": order_pick_address,  "order_delivery_address":order_delivery_address,"order_mid_address": order_mid_address, "order_type": order_type, "order_amount": order_amount,"order_pick_lat": order_pick_lat, "order_pick_long": order_pick_long, "order_delivery_lat": order_delivery_lat, "order_delivery_long": order_delivery_long, "order_mid_lat": order_mid_lat, "order_mid_long": order_mid_long,"order_pick_lugar": order_pick_lugar, "order_deli_lugar": order_deli_lugar, "order_final_lugar": order_final_lugar, "order_contact_name": order_contact_name, "order_contact_num": order_contact_num, "email": email]
        let url = "\(Constants.Server.URL)add_order_reg/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<BaseModel>) in
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Failure Response: \(json ?? "")")
                }
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    func getOrderList(user_id:String, completion: @escaping (OrderList?, String?) -> Void){
        let parameters: Parameters = ["user_id": user_id]
        let url = "\(Constants.Server.URL)getliveorders/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<OrderList>) in
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Failure Response: \(json ?? "")")
                }
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }

    
    
    func getCardNameList(user_id: String, completion: @escaping (CardNameList?, String?) -> Void){
        let parameters: Parameters = ["user_id": user_id]
        let url = "\(Constants.Server.URL)getCardNames/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<CardNameList>) in
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    func getCardInfo(user_id: String, card_name: String, completion: @escaping (CardList?, String?) -> Void){
        let parameters: Parameters = ["user_id": user_id, "card_name": card_name]
        let url = "\(Constants.Server.URL)getCardInfo/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<CardList>) in
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Failure Response: \(json ?? "")")
                }
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    func getSupportInfo(completion: @escaping (SupportList?, String?) -> Void){
        
        let url = "\(Constants.Server.URL)get_support/"
        Alamofire.request(url)
            .validate()
            .responseObject() { (response: DataResponse<SupportList>) in
                
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Failure Response: \(json ?? "")")
                }
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    func getActiveOrder(user_id: String, completion: @escaping (OrderDriverList?, String?) -> Void){
        let parameters: Parameters = ["user_id": user_id]
        let url = "\(Constants.Server.URL)get_user_active_order/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<OrderDriverList>) in
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Failure Response: \(json ?? "")")
                }
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    func getOrderLocations(user_id: String, completion: @escaping (OrderList?, String?) -> Void){
        let parameters: Parameters = ["user_id": user_id]
        let url = "\(Constants.Server.URL)get_order_locations/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<OrderList>) in
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Failure Response: \(json ?? "")")
                }
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    

    
    func getOrder(order_id: String, completion: @escaping (OrderDetailModel?, String?) -> Void){
        let parameters: Parameters = ["order_id": order_id]
        let url = "\(Constants.Server.URL)get_order_details/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<OrderDetailModel>) in
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Failure Response: \(json ?? "")")
                }
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    func getHistory(user_id: String, completion: @escaping (OrderDriverList?, String?) -> Void){
        let parameters: Parameters = ["user_id": user_id]
        let url = "\(Constants.Server.URL)get_user_completed_order/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<OrderDriverList>) in
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Failure Response: \(json ?? "")")
                }
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    func getInvoiceNumber(completion: @escaping (InvoiceModel?, String?) -> Void){
        
        let url = "\(Constants.Server.URL)get_invoice_number/"
        Alamofire.request(url)
            .validate()
            .responseObject() { (response: DataResponse<InvoiceModel>) in
                
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Failure Response: \(json ?? "")")
                }
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    func getFAQ(completion: @escaping (FAQList?, String?) -> Void){
        
        let url = "\(Constants.Server.URL)get_faq_data/"
        Alamofire.request(url)
            .validate()
            .responseObject() { (response: DataResponse<FAQList>) in
                
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Failure Response: \(json ?? "")")
                }
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    func getReceiptImages(order_id: String, completion: @escaping (OrderDetailModel?, String?) -> Void){
        let parameters: Parameters = ["order_id": order_id]
        let url = "\(Constants.Server.URL)get_user_receipt/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<OrderDetailModel>) in
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Failure Response: \(json ?? "")")
                }
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
}

