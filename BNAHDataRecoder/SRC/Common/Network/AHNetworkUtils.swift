//
//  AHNetworkUtils.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/10/17.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import UIKit

class AHNetworkUtils: NSObject {
    public class func requestAuctionItem(realm: String, name: String, completionHandler: @escaping (NSArray?) -> Swift.Void){
        AHNetworkUtils.requestItem(realm: realm, name: name) { (resultData) in
            let urlRealmItemStr = kHostName + kApiAuctionRealm + realm + "/item/" + "\(resultData!["id"]!)"
            
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
}
