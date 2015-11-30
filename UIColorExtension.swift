//
//  UIColorExtension.swift
//  DogeDoge
//
//  Created by ShanMako on 15/11/4.
//  Copyright © 2015年 sspai. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    class func tamanaMainColor() -> UIColor {
        return UIColorFromRGB(0x89b556);
    }
    
    class func tamanaMainColor2() -> UIColor {
        return UIColorFromRGB(0x79b74a);
    }
    
    class func tamanaMainColorPressed() -> UIColor {
        //        return UIColorFromRGB(0xB6CCA1)
        return UIColorFromRGB(0x59bb0c)
    }
    
    class func tamanaSubColor() -> UIColor {
        //        return UIColorFromRGB(0x0C6A91);
        return UIColorFromRGB(0xCEFF1A)
    }
    
    class func sectionBgColor() -> UIColor {
        return UIColorFromRGB(0xF5F5F5)
    }
    
    class func transparentBlack() -> UIColor {
        return UIColorFromRGBA(0x000000, alpha:Float(0.84));
    }
    
    class func pageColor() -> UIColor {
        return UIColorFromRGB(0xF1F1F1);
    }
    
    class func smokeColor() -> UIColor {
        return UIColorFromRGB(0xF1F1F1);
    }
    
    class func lightSmokeColor() -> UIColor {
        return UIColorFromRGB(0xF7F7F7);
    }
    
    class func darkSmokeColor() -> UIColor {
        return UIColorFromRGB(0xDCDCDC);
    }
    
    class func borderColor() -> UIColor {
        return darkSmokeColor()
    }
    
    class func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func UIColorFromRGBA(rgbValue: UInt, alpha: Float) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}
