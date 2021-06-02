//
//  BaseModel.swift
//  iPaths
//
//  Created by Jackson on 5/10/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import Foundation
import ObjectMapper

class UrlModel: Mappable{
    var status: String?
    var url: String?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        url <- map["user_photo"]
    }
}
