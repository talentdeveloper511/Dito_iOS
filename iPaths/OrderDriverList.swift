//
//  OrderDriverList.swift
//  iPaths
//
//  Created by Marko Dreher on 9/13/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import Foundation

import ObjectMapper
class OrderDriverList: Mappable{
    required init?(map: Map) {
        
    }
    var list:[OrderDriver]?
    func mapping(map: Map) {
        list <- map["data"]
    }
}
