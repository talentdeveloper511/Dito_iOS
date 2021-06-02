//
//  OrderList.swift
//  iPaths
//
//  Created by Jackson on 5/21/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import Foundation
import ObjectMapper
class OrderList: Mappable{
    required init?(map: Map) {
        
    }
    var list:[Order]?
    func mapping(map: Map) {
        list <- map["data"]
    }
}
