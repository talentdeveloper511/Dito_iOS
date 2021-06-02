//
//  ErrorClass.swift
//  Applocum
//
//  Created by ApporioMac8 on 20/03/17.
//  Copyright © 2017 Marko Dreher. All rights reserved.
//

import Foundation
import UIKit
//import BRYXBanner
extension NSObject
   
    {
    struct BannerColors {
        static let red = UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000)
        static let green = UIColor(red:48.00/255.0, green:174.0/255.0, blue:51.5/255.0, alpha:1.000)
        static let yellow = UIColor(red:255.0/255.0, green:204.0/255.0, blue:51.0/255.0, alpha:1.000)
        static let blue = UIColor(red:31.0/255.0, green:136.0/255.0, blue:255.0/255.0, alpha:1.000)
    }
    
    func simplemsg(messsage:String)
    {
        let color = UIColor(red:0.46, green:0.31, blue:0.67, alpha:1.0)
        let title = "Delivery Station!!!"
        let subtitle = messsage
        let banner = Banner(title: title, subtitle: subtitle, image: nil, backgroundColor: color)
        banner.springiness = currentSpringiness()
        banner.position = currentPosition()
        //        if inViewSwitch.isOn {
        //            banner.show(self.view, duration: 3.0)
        //        } else {
//        banner.show(duration: 1.0)
//
    }

     func OnApiFailure(message:String,resultcode:Int)
     {
        let color = UIColor(red:0.46, green:0.31, blue:0.67, alpha:1.0)
        let title = "Delivery Station!!!"
        let subtitle = message
        let banner = Banner(title: title, subtitle: subtitle, image: nil, backgroundColor: color)
        banner.springiness = currentSpringiness()
        banner.position = currentPosition()
//        if inViewSwitch.isOn {
//            banner.show(self.view, duration: 3.0)
//        } else {
//            banner.show(duration: 2.0)
        //}

    
    }

    func currentPosition() -> BannerPosition {
        //switch positionSegmentedControl.selectedSegmentIndex {
         return .top
       // default: return .bottom
        //}
    }
    
    func currentSpringiness() -> BannerSpringiness {
       // switch springinessSegmentedControl.selectedSegmentIndex {
         return .none
       // case 1: return .slight
       // default: return .heavy
        //}
    }
    
    func currentColor() -> UIColor {
        //case 0: return BannerColors.red
         return BannerColors.green
        
        //case 2: return BannerColors.yellow
       // default: return BannerColors.blue
       // }
    }
    
    func OnProgressStatus(pstatus: Int) {
        if pstatus == 1
        {
            
            SVProgressHUD.show()
            
            
        }else
        {
            SVProgressHUD.dismiss()
        }
    }

       

}


extension String {
    var validated: String? {
        if self.isEmpty { return nil }
        return self
    }

}



