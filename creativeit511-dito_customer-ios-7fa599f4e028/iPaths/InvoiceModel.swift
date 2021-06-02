//
//  InvoiceModel.swift
//  iPaths
//
//  Created by Marko Dreher on 11/1/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

//
//  UserInfo.swift
//  iPaths
//
//  Created by Jackson on 5/10/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import Foundation
import ObjectMapper
class InvoiceModel : Mappable{
    required init?(map: Map) {
        
    }
    var invoice_num:String?
    var status:Bool?

    
    func mapping(map: Map) {
        invoice_num              <- map["data.invoice_num"]
        status            <- map["status"]

    }
}
