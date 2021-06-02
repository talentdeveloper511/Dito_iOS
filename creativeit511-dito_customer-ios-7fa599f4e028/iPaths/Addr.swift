//
//  Addr.swift
//  iPaths
//
//  Created by Jackson on 5/16/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import ObjectMapper

class Addr: Mappable{
    var addr: String?
    var latitude: String?
    var longtitude: String?
    var name: String?
    var id: String?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        addr <- map["favorite_addr"]
        latitude <- map["latitude"]
        longtitude <- map["longtitude"]
        name <- map["name"]
    }
}
