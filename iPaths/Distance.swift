//
//  Distance.swift
//  iPaths
//
//  Created by Jackson on 5/16/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//
import Foundation
import ObjectMapper

class DistanceModel: Mappable{
    required init?(map: Map) {
        
    }
    var id: String?
    var status: String?
    var price: String?

    func mapping(map: Map) {
        status <- map["status"]
        id <- map["data.distance_price_id"]
        price <- map["data.distance_price_value"]
    }
}
