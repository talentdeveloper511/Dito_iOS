//
//  AddrList.swift
//  iPaths
//
//  Created by Jackson on 5/16/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//


import Foundation
import ObjectMapper
class AddrList: Mappable{
    required init?(map: Map) {
        
    }
    var list:[Addr]?
    func mapping(map: Map) {
        list <- map["data"]
    }
}
