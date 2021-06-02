//
//  TimeModel.swift
//  iPaths
//
//  Created by Marko Dreher on 7/3/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import Foundation
import ObjectMapper

class TimeModel: Mappable{
    var status: String?
    var to_time: String?
    var from_time: String?
    var price: String?
    var distance: String?
    var end_distance: String?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        to_time <- map["to_time"]
        from_time <- map["from_time"]
        price <- map["price"]
        distance <- map["distance"]
        end_distance <- map["end_distance"]
    }
}
