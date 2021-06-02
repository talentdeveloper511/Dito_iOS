//
//  ImageModel.swift
//  iPaths
//
//  Created by Jackson on 5/14/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import Foundation
import ObjectMapper
class ImageModel: Mappable{
    
    var photo: String?
    var name: String?
    required init?(map: Map) {
        
    }

    func mapping(map: Map) {
        name <- map["product_group_name"]
        photo <- map["product_group_image"]
    }
}
