//
//  City.swift
//  iPaths
//
//  Created by Marko Dreher on 6/1/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import Foundation
import ObjectMapper

class City: Mappable{
    
    required init?(map: Map) {
        
    }
    var id: String?
    var city_name: String?
    var city_county: String?
    
    
    func mapping(map: Map) {
        
        id           <- map["id"]
         city_name          <- map["city_name"]
        city_county         <- map["city_county"]
        
    }
    
    
}
