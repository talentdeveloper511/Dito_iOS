//
//  CityList.swift
//  iPaths
//
//  Created by Marko Dreher on 6/1/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import Foundation


import ObjectMapper
class CityList: Mappable{
    required init?(map: Map) {
        
    }
    var list:[City]?
    func mapping(map: Map) {
        list <- map["data"]
}
}
