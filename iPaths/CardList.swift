//
//  CardList.swift
//  iPaths
//
//  Created by Jackson on 5/16/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//


import Foundation
import ObjectMapper
class CardList: Mappable{
    required init?(map: Map) {
        
    }
    var list:[CardModel]?
    func mapping(map: Map) {
        list <- map["data"]
    }
}
