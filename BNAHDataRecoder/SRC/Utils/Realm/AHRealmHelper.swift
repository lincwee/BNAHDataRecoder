//
//  AHRealmHelper.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/11/3.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import UIKit
import RealmSwift

private let kTagHistorySearch = "tagHistorySearch"

class AHRealmHelper: NSObject {
    
    
    //MARK:- basic
    class func realm(ofType: Object.Type) -> Results<Object>? {
        let realm = try! Realm()
        let list = realm.objects(ofType).sorted(byProperty: "addTime", ascending: false)
        return list
    }
    
    class func deleteAll() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    class func addHistory(item: AHHistorySearchItem){
        let realm = try! Realm()
        let itemStored = realm.object(ofType: AHHistorySearchItem.self, forPrimaryKey: item.id)
        
        if itemStored != nil {
            let lastTimes = itemStored!.searchTimes
            item.searchTimes = lastTimes
        }
        item.searchTimes += 1
        item.addTime = AHDateHandler.currentTimeStamp()
        try! realm.write {
            realm.add(item, update: true)
        }
        
    }
    
    class func addHistory(itemName: String) {
        AHNetworkUtils.requestItem(name: itemName) { (reaultDic) in
            if reaultDic == nil {
                return
            }
            
            let item = AHHistorySearchItem()
            item.name = reaultDic?["name"] as! String
            item.icon = reaultDic?["icon"] as! String
            item.id = reaultDic?["id"] as! Int
            item.itemLevel = reaultDic?["itemLevel"] as! Int
            AHRealmHelper.addHistory(item: item)
        }
    }
    
}
