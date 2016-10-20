//
//  UIColor+Common.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/10/16.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func colorWithHex(hexValue : NSInteger, alpha: CGFloat) -> UIColor {
        
        return UIColor.init(colorLiteralRed: Float( CGFloat((hexValue & 0xFF0000) >> 16) / CGFloat(255)),
                            green: Float( CGFloat((hexValue & 0x00FF00) >> 8) / CGFloat(255)),
                            blue: Float( CGFloat((hexValue & 0x0000FF)) / CGFloat(255)),
                            alpha: Float(alpha))
    }
    
    class func colorWithHex(hexValue: NSInteger) -> UIColor {
        return UIColor.colorWithHex(hexValue: hexValue, alpha: 1.0)
    }
    
    
    class func colorWithHexStr(hexStr : String, alpha: CGFloat) -> UIColor {
        var newStr = hexStr
        if newStr.characters.count < 6 {
            return UIColor()
        }
        if hexStr.hasPrefix("#") {
            newStr = newStr.replacingOccurrences(of: "#", with: "")
        }
        
        if hexStr.hasPrefix("0x") {
            newStr = newStr.replacingOccurrences(of: "0x", with: "")
        }
        var hex : UInt32 = 0
        Scanner(string: newStr).scanHexInt32(&hex)
        return UIColor.colorWithHex(hexValue: NSInteger(hex), alpha: alpha)
    }
    
    class func colorWithHexStr(hexStr : String) -> UIColor {
        return UIColor.colorWithHexStr(hexStr: hexStr, alpha: 1)
    }

}
