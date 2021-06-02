//
//  CardName.swift
//  iPaths
//
//  Created by Jackson on 5/18/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import Foundation
import ObjectMapper

class CardName: Mappable{
    
    required init?(map: Map) {
        
    }
    var cardName: String?

    
    
    
    func mapping(map: Map) {

        cardName            <- map["name"]

    }
    
    
}
