//
//  UserInfo.swift
//  iPaths
//
//  Created by Jackson on 5/10/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import Foundation
import ObjectMapper
class Order : Mappable{
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
    func mapping(map: Map) {
        id              <- map["order_id"]
        user            <- map["order_user_id"]
        starttime          <- map["order_start_time"]
        endtime          <- map["order_end_time"]
        type        <- map["order_type"]
        status           <- map["order_status"]
        pickaddress              <- map["order_pick_address"]
        deliaddress            <- map["order_delivery_address"]
        finaladdress          <- map["order_mid_address"]
        driver          <- map["order_driver_id"]
        picklat          <- map["order_pick_lat"]
        picklong        <- map["order_pick_long"]
        delilat           <- map["order_delivery_lat"]
        delilong              <- map["order_delivery_long"]
        finallat            <- map["order_mid_lat"]
        finallong          <- map["order_mid_long"]
        amount             <- map["order_amount"]
        cart_name           <- map["cart_name"]
    }
}
