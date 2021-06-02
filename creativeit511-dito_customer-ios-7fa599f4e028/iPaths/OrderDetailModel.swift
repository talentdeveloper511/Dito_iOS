//
//  OrderDetailModel.swift
//  iPaths
//
//  Created by Marko Dreher on 11/1/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//
//
//  OrderDriver.swift
//  iPaths
//
//  Created by Marko Dreher on 9/13/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//


import Foundation
import ObjectMapper
class OrderDetailModel : Mappable{
    required init?(map: Map) {
        
    }
    var id:String?
    var user:String?
    var starttime:String?
    var endtime:String?
    var type: String?
    var status:String?
    var pickaddress: String?
    var deliaddress: String?
    var finaladdress: String?
    var driver: String?
    var picklat:String?
    var picklong:String?
    var delilat: String?
    var delilong: String?
    var finallat: String?
    var finallong: String?
    var amount: String?
    var cart_name: String?
    var driver_name:String?
    var driver_photo: String?
    var driver_phone: String?
    var driver_email: String?
    var latitude: String?
    var longitude: String?
    var receiptBack: String?
    var receiptFront: String?
    var responseStatus: Bool?
    
    
    
    func mapping(map: Map) {
        responseStatus <- map["status"]
        id              <- map["data.order_id"]
        user            <- map["data.order_user_id"]
        starttime          <- map["data.order_start_time"]
        endtime          <- map["data.order_end_time"]
        type        <- map["data.order_type"]
        status           <- map["data.order_status"]
        pickaddress              <- map["data.order_pick_address"]
        deliaddress            <- map["data.order_delivery_address"]
        finaladdress          <- map["data.order_mid_address"]
        driver          <- map["data.order_driver_id"]
        picklat          <- map["data.order_pick_lat"]
        picklong        <- map["data.order_pick_long"]
        delilat           <- map["data.order_delivery_lat"]
        delilong              <- map["data.order_delivery_long"]
        finallat            <- map["data.order_mid_lat"]
        finallong          <- map["data.order_mid_long"]
        amount             <- map["data.order_amount"]
        cart_name           <- map["data.cart_name"]
        latitude            <- map["data.latitude"]
        longitude           <- map["data.longitude"]
        driver_name         <- map["data.driver_name"]
        driver_photo         <- map["data.driver_photo"]
        driver_email         <- map["data.driver_email"]
        driver_phone         <- map["data.driver_phone_num"]
        
        
        receiptBack         <- map["data.back"]
        receiptFront        <- map["data.front"]
    }
}
