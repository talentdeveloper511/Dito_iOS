//
//  OrderDriver.swift
//  iPaths
//
//  Created by Marko Dreher on 9/13/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//


import Foundation
import ObjectMapper
class OrderDriver : Mappable{
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
    var plateNumber: String?
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
        latitude            <- map["latitude"]
        longitude           <- map["longitude"]
        driver_name         <- map["driver_name"]
        driver_photo         <- map["driver_photo"]
        driver_email         <- map["driver_email"]
        driver_phone         <- map["driver_phone_num"]
   
        plateNumber          <- map["driver_plate_number"]
        receiptBack         <- map["back"]
        receiptFront        <- map["front"]
    }
}
