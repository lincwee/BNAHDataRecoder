//
//  AHDateHandler.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/10/29.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import UIKit

class AHDateHandler: NSObject {
    class func date(timeStamp : Double) -> Date? {
        let date = Date(timeIntervalSince1970: timeStamp)
        return date
    }
    
    class func dateString(timeStamp : Double, format: String) -> String {
        let dformatter = DateFormatter()
        dformatter.dateFormat = format
        let date = AHDateHandler.date(timeStamp: timeStamp)
        
        let dateStr = dformatter.string(from: date!)
        return dateStr
    }
    
    
}
