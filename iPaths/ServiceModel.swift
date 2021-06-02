//
//  ServiceModel.swift
//  iPaths
//
//  Created by Jackson on 5/15/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import Foundation
import ObjectMapper
class ServiceModel: Mappable{
    
    var photo: String?
    var price: String?
    var name: String?
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        price <- map["service_price"]
        photo <- map["service_photo"]
        name <- map["service_name"]
    }
}
