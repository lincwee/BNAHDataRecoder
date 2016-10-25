//
//  String+Common.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/10/16.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import Foundation
import UIKit

extension String {
    //sub string function
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
    
    var firstChar : String! {
        get {
            if self.characters.count >= 1 {
                return self.substring(to: 1)
            }
            else {
                return ""
            }
        }
    }
    
    //convert string to Gold Showing Syle
    //like "123456" -> "12金34银56铜"
    func convertToGoldMoneyType() -> String {
        let totalMoney = Int64(self)
        if totalMoney == nil {
            return "-"
        }
        let goldNum = totalMoney! / 10000
        let silverNum = (totalMoney! % 10000) / 100
        let copperNum = (totalMoney! % 100)
        
        
        return  (goldNum == 0 ? "" : "\(goldNum)金") + (silverNum == 0 ? "" : "\(silverNum)银") + (copperNum == 0 ? "" : "\(copperNum)铜")
    }
}
