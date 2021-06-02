//
//  TimeList.swift
//  iPaths
//
//  Created by Marko Dreher on 7/3/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import Foundation
import ObjectMapper
class TimeList: Mappable{
    required init?(map: Map) {
        
    }
    
    var list:[TimeModel]?
    func mapping(map: Map) {
        list <- map["data"]
    }
}
