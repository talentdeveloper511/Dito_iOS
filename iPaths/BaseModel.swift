//
//  BaseModel.swift
//  iPaths
//
//  Created by Jackson on 5/14/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//


import ObjectMapper

class BaseModel: Mappable{
    var status: Bool?
    var data: String?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        data <- map["data"]
    }
}
