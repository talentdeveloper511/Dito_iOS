//
//  CartModel.swift
//  iPaths
//
//  Created by Jackson on 5/15/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import Foundation

import ObjectMapper
class CartModel : Mappable{
    required init?(map: Map) {
        
    }
    var cart_id: String?
    var id:String?
    var Name:String?
    var price: String?
    var liter: String?
    var photo: String?
    var quantity: String?
    var cart_name: String?
    
    func mapping(map: Map) {
        cart_id          <- map["cart_id"]
        id              <- map["product_id"]
        Name            <- map["product_name"]
        photo          <- map["product_photo"]
        liter              <- map["product_liter"]
        price            <- map["product_price"]
        quantity          <- map["quantity"]
        cart_name       <- map["cart_name"]
    }
}
