//
//  UserInfo.swift
//  iPaths
//
//  Created by Jackson on 5/10/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import Foundation
import ObjectMapper
class UserInfo : Mappable{
    required init?(map: Map) {
        
    }
    var id:String?
    var Name:String?
    var email:String?
    var photo:String?
    var password: String?
    var phone:String?
    var office_num: String?
    var business: String?
    var month_ship: String?
    var type: String?
    var apiKey:String?
    var pushKeys:[String]?
    var status:Bool?
    var limit:String?
    var current_state: String?
    
    func mapping(map: Map) {
        id              <- map["user_data.user_id"]
        Name            <- map["user_data.user_name"]
        email          <- map["user_data.user_email"]
        photo          <- map["user_data.user_photo"]
        password        <- map["user_data.user_password"]
        phone           <- map["user_data.user_phone_num"]
        office_num              <- map["user_data.user_office_num"]
        business            <- map["user_data.user_business"]
        month_ship          <- map["user_data.user_month_ship"]
        limit            <- map["user_data.user_credit_limit"]
        current_state          <- map["user_data.user_current"]
        type          <- map["user_data.user_type"]
        
//        mobileAppAccess  <- map["data.profile.mobile_app_access"]
//        apiKey          <- map["data.profile.apikey"]
         status          <- map["status"]
//        pushKeys        <- map["data.profile.pushKeys"]
    }
}
