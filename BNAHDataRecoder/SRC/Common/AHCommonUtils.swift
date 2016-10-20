//
//  AHCommonUtils.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/10/18.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import UIKit

enum AHItemImageSizeType {
    case itemSize18
    case itemSize36
    case iTemSize56
}

let AHItemDataCache = "itemDataCache"
let AHRealmData = "realm_Data"

class AHCommonUtils: NSObject {
    
    /// get Image url by given param
    ///
    /// - parameter name:     image target item's name
    /// - parameter sizeType: image size
    ///
    /// - returns: image's url
    public class func getImageUrl(name : String, sizeType : AHItemImageSizeType) -> URL {
        var size = String()
        switch sizeType {
        case .itemSize18:
            size = "18"
            break
        case .itemSize36:
            size = "36"
            break
        case .iTemSize56 :
            size = "56"
            break
        }
        
        let urlStr = "http://content.battlenet.com.cn/wow/icons/\(size)/\(name).jpg"
        return URL(string: urlStr)!
    }
    
    public class func getItemIDFromCache(name: String) -> String? {
        let userDefault = UserDefaults.standard
        if let itemDataCache = userDefault.object(forKey: AHItemDataCache) {
            let itemList = itemDataCache as! NSArray
            for item  in itemList {
               let dicItem = item as! NSDictionary
                if dicItem["name"] as! String == name {
                    return dicItem["id"] as? String
                }
            }
        }
        return ""
    }
    
// realm data
    public class func initRealmData() {
        let realmSavedDic = UserDefaults.standard.object(forKey: AHRealmData)
        if realmSavedDic != nil {
            return
        }
        let realmJson = Bundle.main.path(forResource: "realm", ofType: "json")
        let realmData = NSData(contentsOfFile: realmJson!)
        let realmDic = try! JSONSerialization.jsonObject(with: realmData as! Data, options: .mutableContainers) as! NSArray
        //set realm data
        UserDefaults.standard.set(realmDic, forKey: AHRealmData)
    }

    
    public class var realmList : NSArray {
        get {
            let realmList = UserDefaults.standard.object(forKey: AHRealmData) as! NSArray
            return realmList
        }
    }
    
}
