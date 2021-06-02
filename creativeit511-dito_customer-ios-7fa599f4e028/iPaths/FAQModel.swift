//
//  FAQModel.swift
//  iPaths
//
//  Created by Marko Dreher on 10/9/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import Foundation
import ObjectMapper

class FAQModel: Mappable{
    
    var group_name: String?
    var question: String?
    var answer: String?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        group_name <- map["group_name"]
        question <- map["question"]
        answer <- map["answer"]
    }
}
