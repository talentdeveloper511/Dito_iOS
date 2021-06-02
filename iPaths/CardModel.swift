//
//  CardModel.swift
//  iPaths
//
//  Created by Jackson on 5/16/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//


import Foundation
import ObjectMapper

class CardModel: Mappable{
    
    required init?(map: Map) {
        
    }
    var cardName: String?
    var cardNum: String?
    var cardCVC: String?
    var cardDate: String?
    var id: String?
    

    
    func mapping(map: Map) {
        id                  <- map["id"]
        cardNum              <- map["card_num"]
        cardName            <- map["name"]
        cardCVC          <- map["cvc"]
        cardDate              <- map["date"]
    }
    
    
}
