//
//  Constants.swift
//  Local18
//
//  Created by iMacDev on 12/6/17.
//  Copyright © 2017 iMacDev. All rights reserved.
//
import Foundation
import UIKit


class Constants{
    struct Server{

        static let URL:String = "http://appdito.ditoexpress.com/apis/"
        static let SENDBIRD_APP_ID = "B1827938-0F36-4988-BB9B-DEA33ABCF49D"
        static let RESPONSE_MESSAGE         = "message"
    }
    
    static let redColor:UIColor = UIColor(red: 0xd4/255.0, green:0x10/255.0, blue: 0x28/255.0, alpha:1.0)
    static let darkColor:UIColor = UIColor(red: 0x25/255.0, green:0x30/255.0, blue: 0x46/255.0, alpha:1.0)
    static let menuSelColor:UIColor = UIColor(red: 0x26/255.0, green:0x2E/255.0, blue: 0x70/255.0, alpha:0.8)
    static let IS_LOGIN:String = "islogedin"
    static let TOKEN:String = "remember_token"
    static let REGISTERED: Int = 1
    static let UPCOMING: Int = 0
    static let LONGTITUDE = "longtitude"
    static let LATITUDE = "latitude"
    static let defaultCurrency = "usd"
    static let defaultDescription = "Purchase from Dito iOS"
    static let GOOGLE_PLACESDK_API = "AIzaSyA5os-lLvgVneN1434lMNcupgoI8vhA9Gw"
    static let GOOGLE_PLACE_API = "AIzaSyCy1eAsCYI2pbmJhksB-X6UlfZ3LgwAYyg"
    static let publishableKey = "pk_test_5slLS8H4gkZVHzhOzcwMLjwS"
    
    
    static let MAPBOX_KEY = "pk.eyJ1IjoibWFya29kcmVoZXIwNTExIiwiYSI6ImNqbWFpZ25sZDA5eTQzdnE0Z3R6Mndva2QifQ.SFbGa5mEft9wgKat9Tsy8g"
    
    static func navigationBarTitleColor() -> UIColor {
        return UIColor(red: 128.0/255.0, green: 90.0/255.0, blue: 255.0/255.0, alpha: 1)
    }
    
    static func navigationBarSubTitleColor() -> UIColor {
        return UIColor(red: 142.0/255.0, green: 142.0/255.0, blue: 142.0/255.0, alpha: 1)
    }
    
    static func navigationBarTitleFont() -> UIFont {
        return UIFont(name: "HelveticaNeue", size: 16.0)!
    }
    
    static func navigationBarSubTitleFont() -> UIFont {
        return UIFont(name: "HelveticaNeue-LightItalic", size: 10.0)!
    }
    
    static func textFieldLineColorNormal() -> UIColor {
        return UIColor(red: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 1)
    }
    
    static func textFieldLineColorSelected() -> UIColor {
        return UIColor(red: 140.0/255.0, green: 109.0/255.0, blue: 238.0/255.0, alpha: 1)
    }
    
    static func nicknameFontInMessage() -> UIFont {
        return UIFont(name: "HelveticaNeue", size: 12.0)!
    }
    
    static func nicknameColorInMessageNo0() -> UIColor {
        return UIColor(red: 45.0/255.0, green: 27.0/255.0, blue: 225.0/255.0, alpha: 1)
    }
    
    static func nicknameColorInMessageNo1() -> UIColor {
        return UIColor(red: 53.0/255.0, green: 163.0/255.0, blue: 251.0/255.0, alpha: 1)
    }
    
    static func nicknameColorInMessageNo2() -> UIColor {
        return UIColor(red: 128.0/255.0, green: 90.0/255.0, blue: 255.0/255.0, alpha: 1)
    }
    
    static func nicknameColorInMessageNo3() -> UIColor {
        return UIColor(red: 207.0/255.0, green: 72.0/255.0, blue: 251.0/255.0, alpha: 1)
    }
    
    static func nicknameColorInMessageNo4() -> UIColor {
        return UIColor(red: 226.0/255.0, green: 27.0/255.0, blue: 225.0/255.0, alpha: 1)
    }
    
    static func messageDateFont() -> UIFont {
        return UIFont(name: "HelveticaNeue", size: 10.0)!
    }
    
    static func messageDateColor() -> UIColor {
        return UIColor(red: 191.0/255.0, green: 191.0/255.0, blue: 191.0/255.0, alpha: 1)
    }
    
    static func incomingFileImagePlaceholderColor() -> UIColor {
        return UIColor(red: 238.0/255.0, green: 241.0/255.0, blue: 246.0/255.0, alpha: 1)
    }
    
    static func messageFont() -> UIFont {
        return UIFont(name: "HelveticaNeue", size: 16.0)!
    }
    
    static func outgoingMessageColor() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
    }
    
    static func incomingMessageColor() -> UIColor {
        return UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1)
    }
    
    static func outgoingFileImagePlaceholderColor() -> UIColor {
        return UIColor(red: 128.0/255.0, green: 90.0/255.0, blue: 255.0/255.0, alpha: 1)
    }
    
    static func openChannelLineColorNo0() -> UIColor {
        return UIColor(red: 45.0/255.0, green: 227.0/255.0, blue: 255.0/255.0, alpha: 1)
    }
    
    static func openChannelLineColorNo1() -> UIColor {
        return UIColor(red: 53.0/255.0, green: 163.0/255.0, blue: 251.0/255.0, alpha: 1)
    }
    
    static func openChannelLineColorNo2() -> UIColor {
        return UIColor(red: 128.0/255.0, green: 90.0/255.0, blue: 255.0/255.0, alpha: 1)
    }
    
    static func openChannelLineColorNo3() -> UIColor {
        return UIColor(red: 207.0/255.0, green: 72.0/255.0, blue: 251.0/255.0, alpha: 1)
    }
    
    static func openChannelLineColorNo4() -> UIColor {
        return UIColor(red: 226.0/255.0, green: 72.0/255.0, blue: 195.0/255.0, alpha: 1)
    }
    
    static func leaveButtonColor() -> UIColor {
        return UIColor.red
    }
    
    static func hideButtonColor() -> UIColor {
        return UIColor(red: 116.0/255.0, green: 127.0/255.0, blue: 145.0/255.0, alpha: 1)
    }
    
    static func leaveButtonFont() -> UIFont {
        return UIFont(name: "HelveticaNeue", size: 16.0)!
    }
    
    static func hideButtonFont() -> UIFont {
        return UIFont(name: "HelveticaNeue", size: 16.0)!
    }
    
    static func distinctButtonSelected() -> UIFont {
        return UIFont(name: "HelveticaNeue-Medium", size: 18.0)!
    }
    
    static func distinctButtonNormal() -> UIFont {
        return UIFont(name: "HelveticaNeue", size: 18.0)!
    }
    
    static func navigationBarButtonItemFont() -> UIFont {
        return UIFont(name: "HelveticaNeue", size: 16.0)!
    }
    
    static func memberOnlineTextColor() -> UIColor {
        return UIColor(red: 41.0/255.0, green: 197.0/255.0, blue: 25.0/255.0, alpha: 1)
    }
    
    static func memberOfflineDateTextColor() -> UIColor {
        return UIColor(red: 142.0/255.0, green: 142.0/255.0, blue: 142.0/255.0, alpha: 1)
    }
    
    static func connectButtonColor() -> UIColor {
        return UIColor(red: 123.0/255.0, green: 95.0/255.0, blue: 217.0/255.0, alpha: 1)
    }
    
    static func urlPreviewDescriptionFont() -> UIFont {
        return UIFont(name: "HelveticaNeue-Light", size: 12.0)!
    }
    
}

func convertDateFormat(_ dateString:String, from:String, to: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = from
    let date = dateFormatter.date(from: dateString)
    dateFormatter.dateFormat = to
    let result = dateFormatter.string(from: date!)
    return result
}

func removeSeqChars(_ string:String) -> String {
    var arrString = string.split(separator: " ")
    if arrString.count == 3 {
        arrString[1] = arrString[1].prefix(2)
        return "\(arrString[0]) \(arrString[1]) \(arrString[2])"
    }else{
        return string
    }
    
}
//
//  Constants.swift
//  iPaths
//
//  Copyright © 2018 Marko Dreher. All rights reserved.
//


