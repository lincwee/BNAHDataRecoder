//
//  AHNetworkUtils.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/10/17.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import UIKit

class AHNetworkUtils: NSObject {
    
    public class func requestItem(name: String, completionHandler: @escaping (NSDictionary?) -> Swift.Void){
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
    
    
    public class func requestAuctionItem(realm: String, name: String, completionHandler: @escaping (NSArray?) -> Swift.Void){
        AHNetworkUtils.requestItem(name: name) { (resultData) in
            if resultData == nil {
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
    
    public class func requestItemAuctionMinPrice(realm: String, name: String, completionHandler: @escaping (NSDictionary?) -> Swift.Void) {

        AHNetworkUtils.requestItem(name: name) { (itemDataDic) in
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
    
    public class func requestGetItemNames(name: String, completionHandler: @escaping (NSArray?) -> Swift.Void) {
        let session = URLSession.shared
        session.configuration.requestCachePolicy = .useProtocolCachePolicy
        let urtStr = kHostName + kApiItemNames + "\(name)"
        let urlStrEncoding = URL(string: urtStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        session.dataTask(with: urlStrEncoding!) { (data, response, error) in
            if let resultData = data {
                let dataList = try? JSONSerialization.jsonObject(with: resultData, options: .mutableContainers) as! NSArray
                completionHandler(dataList)
                return
            }
            else {
                completionHandler([])
                return
            }
        }.resume()
    }
    
    // all realm auction summary data
    public class func requestRealmsSummary(completionHandler: @escaping (NSArray?) -> Swift.Void) {
        let session = URLSession.shared
        session.configuration.requestCachePolicy = .useProtocolCachePolicy
        let urlStr = kHostName + kApiAuctionSummmary
        session.dataTask(with: URL(string: urlStr)!) { (data, URLResponse, Error) in
            if let resultData = data {
                let dataList = try? JSONSerialization.jsonObject(with: resultData, options: .mutableContainers) as! NSArray
                completionHandler(dataList)
                return
            }
            else {
                completionHandler([])
                return
            }
        }.resume()
    }
    
    // target realm&item data
    public class func requestItemHistoryData(name: String, realmId: String, completionHandler : @escaping (NSArray?) -> Swift.Void) {
        AHNetworkUtils.requestItem(name: name) { (resultData) in
            if resultData == nil {
                completionHandler([])
                return
            }
            
            let urlStr = kHostName + kApiAuctionHistory + realmId + "/item/" + "\((resultData?["id"])!)"
            let session = URLSession.shared
            session.configuration.requestCachePolicy = .useProtocolCachePolicy
            session.dataTask(with: URL(string: urlStr)!, completionHandler: { (data, request, error) in
                if let dataResult = data {
                    let dataList = try? JSONSerialization.jsonObject(with: dataResult, options: .mutableContainers) as! NSArray
                    
                    completionHandler(dataList)
                }
                else {
                    completionHandler([])
                }
            }).resume()
            
        }
    }
    public class func requestItemPastData(name: String, realmId: String, completionHandler : @escaping (NSArray?) -> Swift.Void) {
        AHNetworkUtils.requestItem(name: name) { (resultData) in
            if resultData == nil {
                completionHandler([])
                return
            }
            
            let urlStr = kHostName + kApiAuctionPast + realmId + "/item/" + "\((resultData?["id"])!)"
            let session = URLSession.shared
            session.configuration.requestCachePolicy = .useProtocolCachePolicy
            session.dataTask(with: URL(string: urlStr)!, completionHandler: { (data, response, error) in
                if let dataResult = data {
                    let dataList = try? JSONSerialization.jsonObject(with: dataResult, options: .mutableContainers) as! NSArray
                    
                    completionHandler(dataList)
                }
                else {
                    completionHandler([])
                }
            }).resume()
        }
    }
    
    public class func requestWowToken(completionHandler: @escaping (NSArray?) -> Void) {
        let urlStr = kHostName + kApiWowToken
        let session = URLSession.shared
        session.configuration.requestCachePolicy = .useProtocolCachePolicy
        session.dataTask(with: URL(string: urlStr)!, completionHandler:{ (data, response, error) in
            if let dataResult = data {
                let dataList = try? JSONSerialization.jsonObject(with: dataResult, options: .mutableContainers) as! NSArray
                completionHandler(dataList)
            }
            else {
                completionHandler([])
            }
        }).resume()
    }
    
    //MARK:- BattleNet api
    
    public class func requestItemFromBattleNet(name: String, completionHandler: @escaping (NSDictionary?)->Void) {
        AHNetworkUtils.requestItem(name: name) { (resultData) in
            if resultData == nil {
                return
            }
            let session = URLSession.shared
            session.configuration.requestCachePolicy = .useProtocolCachePolicy
            let urtStr = kHostBattleNetTWName + "item/" + "\((resultData?["id"])!)" + "?locale=\(kApiBattleNetLocale)&apikey=\(kApiBattleNetKey)"
            let getItemURL = URL(string: urtStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            session.dataTask(with: getItemURL!) { (data, response, error) in
                if let resultData = data {
                    let result = try? JSONSerialization.jsonObject(with: resultData, options: .allowFragments) as! NSDictionary
                    if let resultData = result{
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
}


