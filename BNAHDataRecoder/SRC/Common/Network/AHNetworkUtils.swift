//
//  AHNetworkUtils.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/10/17.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import UIKit
import Alamofire

class AHNetworkUtils: NSObject {
    public class func requestAuctionItem(realm: String, name: String, completionHandler: @escaping (NSArray?) -> Swift.Void){
        AHNetworkUtils.requestItem(realm: realm, name: name) { (resultData) in
            if resultData != nil {
                return
            }
            let urlRealmItemStr = kHostName + kApiAuctionRealm + realm + "/item/" + "\(resultData?["id"]!)"
            
            let urlRealmItem = URL(string: urlRealmItemStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            let session = URLSession.shared
            session.dataTask(with: urlRealmItem!, completionHandler: { (data, response, errpr) in
                if let resultRealmData = data {
                    let realmItemList = try? JSONSerialization.jsonObject(with: resultRealmData, options: .allowFragments) as! NSArray
                    completionHandler(realmItemList)
                }
                else {
                    completionHandler(nil)
                }
            }).resume()
 
        }
    }
    
    public class func requestItem(realm: String, name: String, completionHandler: @escaping (NSDictionary?) -> Swift.Void){
        let session = URLSession.shared
        session.configuration.requestCachePolicy = .useProtocolCachePolicy
        let urtStr = kHostName + kApiItem + name
        let getItemURL = URL(string: urtStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        session.dataTask(with: getItemURL!) { (data, response, error) in
            if let resultData = data {
                let result = try? JSONSerialization.jsonObject(with: resultData, options: .allowFragments) as! NSArray
                if let resultData = result?.objectSafe(index: 0) as? NSDictionary{
                    completionHandler(resultData)
                }
                else {
                    print("data has no value")
                    completionHandler(nil)
                }
            }
            else {
                print("no value")
                completionHandler(nil)
            }
            }.resume()
    }
    
    public class func requestItemAuctionMinPrice(realm: String, name: String, completionHandler: @escaping (NSDictionary?) -> Swift.Void) {

        AHNetworkUtils.requestItem(realm: realm, name: name) { (itemDataDic) in
            if itemDataDic == nil {
                completionHandler(nil)
                return
            }
            let itemId = itemDataDic?["id"]!
            let urlStr = kHostName + kApiAuctionItem + "\(itemId!)"
            let session = URLSession.shared
            session.configuration.requestCachePolicy = .useProtocolCachePolicy
            session.dataTask(with: URL(string: urlStr)!, completionHandler: { (data, response, error) in
                if let resultData = data {
                    let resultList = try? JSONSerialization.jsonObject(with: resultData, options: .allowFragments) as! NSArray
                    for eveItem in resultList! {
                        let eveItemList = eveItem as! NSArray
                        let realmId = eveItemList.objectSafe(index: 0) as? NSNumber
                        if Int(realmId!) == Int(realm) {
                           let resultDic = ["realmID": "\(eveItemList.objectSafe(index: 0)!)",
                                            "minPrice": "\(eveItemList.objectSafe(index: 1)!)"]
                            completionHandler(resultDic as NSDictionary?)
                            return
                        }
                    }
                    completionHandler(nil)
                    return
                }
                else {
                    completionHandler(nil)
                }
            }).resume()
        }
        return
    }
}
