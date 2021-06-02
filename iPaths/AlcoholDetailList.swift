//
//  AlcoholDetailList.swift
//  iPaths
//
//  Created by Jackson on 5/14/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import Foundation
import ObjectMapper
class AlcoholDetailList: Mappable{
    required init?(map: Map) {
        
    }
    var list:[ProductModel]?
    func mapping(map: Map) {
        list <- map["data"]
    }
}
