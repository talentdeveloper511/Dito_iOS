//
//  SlideList.swift
//  iPaths
//
//  Created by Marko Dreher on 7/3/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import Foundation
import ObjectMapper
class SlideList: Mappable{
    required init?(map: Map) {
        
    }
    
    var list:[SlideModel]?
    var status: Bool?
    func mapping(map: Map) {
        list <- map["data"]
        status <- map["status"]
    }
}
