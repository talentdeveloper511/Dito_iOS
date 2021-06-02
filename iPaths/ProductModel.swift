//
//  ProductModel.swift
//  iPaths
//
//  Created by Jackson on 5/14/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//


import Foundation
import ObjectMapper
class ProductModel : Mappable{
    required init?(map: Map) {
        
    }
    var id:String?
    var Name:String?
    var price: String?
    var quantity: String?
    var photo: String?

    func mapping(map: Map) {
        id              <- map["product_id"]
        Name            <- map["product_name"]
        photo          <- map["product_photo"]
        quantity              <- map["product_quantity"]
        price            <- map["product_price"]
    }
}
