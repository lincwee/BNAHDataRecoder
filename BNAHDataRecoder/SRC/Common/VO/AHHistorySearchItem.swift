//
//  AHHistorySearchItem.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/11/4.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import UIKit
import RealmSwift

class AHHistorySearchItem: Object {
    dynamic var name = ""
    dynamic var id = 0
    dynamic var icon = ""
    dynamic var itemLevel = 0
    dynamic var addTime = Double(0)
    dynamic var searchTimes = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
