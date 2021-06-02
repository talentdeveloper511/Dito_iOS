//
//  Support.swift
//  iPaths
//
//  Created by Jackson on 5/24/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import Foundation
import ObjectMapper

class Support: Mappable{
    
    required init?(map: Map) {
        
    }
    var url: String?
    var phone: String?
    var email: String?
    
    
    func mapping(map: Map) {
        
        url           <- map["url"]
         phone           <- map["phone"]
         email         <- map["email"]
        
    }
    
    
}
