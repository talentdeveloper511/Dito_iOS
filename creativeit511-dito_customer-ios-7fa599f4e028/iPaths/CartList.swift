//
//  CartList.swift
//  iPaths
//
//  Created by Jackson on 5/15/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import Foundation
import ObjectMapper
class CartList: Mappable{
    required init?(map: Map) {
        
    }
    var list:[CartModel]?
    func mapping(map: Map) {
        list <- map["data"]
    }
}
