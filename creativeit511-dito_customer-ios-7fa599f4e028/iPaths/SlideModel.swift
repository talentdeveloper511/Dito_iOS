//
//  SlideModel.swift
//  iPaths
//
//  Created by Marko Dreher on 7/3/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import Foundation
import ObjectMapper

class SlideModel: Mappable{
    var status: String?
    var url: String?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        url <- map["url"]
    }
}
