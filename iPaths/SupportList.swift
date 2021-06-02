//
//  SupportList.swift
//  iPaths
//
//  Created by Jackson on 5/24/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import Foundation

import ObjectMapper
class SupportList: Mappable{
    required init?(map: Map) {
        
    }
    var list:[Support]?
    func mapping(map: Map) {
        list <- map["data"]
    }
}
