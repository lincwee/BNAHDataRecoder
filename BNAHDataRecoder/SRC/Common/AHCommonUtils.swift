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
let AHDefaultRealm = "default_realm"

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
        var realmDic = try! JSONSerialization.jsonObject(with: realmData as! Data, options: .mutableContainers) as! NSArray
        //sort array by name's pinyin first char
        realmDic = realmDic.sorted { (item1, item2) -> Bool in
            let dic1 = item1 as! NSDictionary
            let dic2 = item2 as! NSDictionary
            let dic1NamePY = (dic1["name"] as! String).applyingTransform(.toLatin, reverse: false)
            let dic2NamePY = (dic2["name"] as! String).applyingTransform(.toLatin, reverse: false)
            let firstChar1 = (dic1NamePY?.firstChar)! as String
            let firstChar2 = (dic2NamePY?.firstChar)! as String
            
            return firstChar1 < firstChar2
            } as NSArray!
        //set realm data
        UserDefaults.standard.set(realmDic, forKey: AHRealmData)
    }

    
    public class var realmList : NSArray {
        get {
            let realmList = UserDefaults.standard.object(forKey: AHRealmData) as! NSArray
            return realmList.copy() as! NSArray
        }
    }
    
    public class var defaultRealm : NSDictionary? {
        get {
            let defaultValue = UserDefaults.standard.object(forKey: AHDefaultRealm) as? NSDictionary
            if let value = defaultValue {
                return value
            }
            else {
                let realmList = AHCommonUtils.realmList
                //if not default value ,choose id = 158 server
                return realmList.objectSafe(index: 158) as? NSDictionary
            }
        }
        
        set {
            if newValue == nil {
                return
            }
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kNotificationDefaultRealmChanged), object: nil)
            UserDefaults.standard.set(newValue, forKey: AHDefaultRealm)
        }
    }
    
}
