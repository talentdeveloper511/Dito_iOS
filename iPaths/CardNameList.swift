//
//  CardNameList.swift
//  iPaths
//
//  Created by Jackson on 5/18/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import Foundation
import ObjectMapper
class CardNameList: Mappable{
    required init?(map: Map) {
        
    }
    var list:[CardName]?
    func mapping(map: Map) {
        list <- map["data"]
    }
}
