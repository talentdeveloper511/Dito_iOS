//
//  AlcoholList.swift
//  iPaths
//
//  Created by Jackson on 5/14/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import Foundation
import ObjectMapper
class AlcoholList: Mappable{
    required init?(map: Map) {
        
    }
    
    var list:[ImageModel]?
     func mapping(map: Map) {
        list <- map["data"]
    }
}
