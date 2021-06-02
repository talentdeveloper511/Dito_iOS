//
//  FAQList.swift
//  iPaths
//
//  Created by Marko Dreher on 10/9/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import Foundation
import ObjectMapper
class FAQList: Mappable{
    required init?(map: Map) {
        
    }
    
    var list:[FAQModel]?
    func mapping(map: Map) {
        list <- map["data"]
    }
}
