//
//  Track.swift
//  iPaths
//
//  Created by Lebron on 3/29/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import Foundation

class Track{
    var driverImage:UIImage
    var driverName:String
    var time:String
    var amount:String
    
    init(driverImage: UIImage, driverName: String, time: String, amount: String) {
        self.driverImage = #imageLiteral(resourceName: "driver")
        self.amount = amount
        self.driverName = driverName
        self.time = time
    }
}
