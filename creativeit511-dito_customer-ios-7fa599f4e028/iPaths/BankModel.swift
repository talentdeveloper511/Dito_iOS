//
//  BankModel.swift
//  iPaths
//
//  Created by Jackson on 5/15/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import Foundation

import ObjectMapper
class BankModel: Mappable{
    
    var photo: String?
    var price: String?
    var name: String?
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        price <- map["bank_price"]
        photo <- map["bank_photo"]
        name <- map["bank_name"]
    }
}
