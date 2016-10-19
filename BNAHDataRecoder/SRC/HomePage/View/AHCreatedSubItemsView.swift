//
//  AHCreatedSubItemsView.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/10/17.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import UIKit

class AHCreatedSubItemsView: UIView {

    var _subItemTotalData = NSDictionary()
    var _createdByData = NSArray()
    
    public init(subItemData: NSDictionary){
        super.init(frame: CGRect.zero)
        let tempList = subItemData.object(forKey: "createdBy") as! NSArray
        _subItemTotalData = subItemData
        _createdByData = tempList

        handleSubItemData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func handleSubItemData() {
        // if no data
        if _createdByData.count == 0 {
            return
        }
        self.width = kScreenW
        
        let topView = createTopCreatedItemView()
        self.addSubview(topView)
        
        var lastSubView = UIView(frame: CGRect.zero)
        lastSubView.bottom = topView.bottom
        for eveData in _createdByData {
            let blockView = createEveryBlockItemView(eveBlockData: eveData as! NSDictionary)
            self.addSubview(blockView)
            blockView.top = lastSubView.bottom + 5
            self.height = blockView.bottom
            lastSubView = blockView
        }
   
    }
    
    
    private func createTopCreatedItemView() -> UIView {
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 130))
        let imageName = _subItemTotalData["icon"] as! String
        let topItemImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
        topView.addSubview(topItemImageView)
        topItemImageView.sd_setImage(with: AHCommonUtils.getImageUrl(name: imageName, sizeType: .iTemSize56)) { (image, error, type, url) in
        }
        
        let nameLabel = UILabel(frame: CGRect.zero)
        topView.addSubview(nameLabel)
        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont.systemFont(ofSize: 20)
        nameLabel.text = "\(_subItemTotalData["name"]!)"
        nameLabel.sizeToFit()
        nameLabel.top = topItemImageView.bottom + 10
        nameLabel.left = topItemImageView.left
        
        let levelLabel = UILabel(frame: .zero)
        topView.addSubview(levelLabel)
        levelLabel.textColor = UIColor.black
        levelLabel.font = UIFont.systemFont(ofSize: 16)
        levelLabel.text = "需要等级: \(_subItemTotalData["itemLevel"]!)"
        levelLabel.sizeToFit()
        levelLabel.top = nameLabel.bottom
        levelLabel.left = nameLabel.left
        
        self.height = topView.height
        
        return topView
    }
    
    private func createEveryBlockItemView(eveBlockData: NSDictionary) -> UIView {
        let blockView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 0))
        var totalPriceList = NSMutableArray(capacity: 0)
        let subItemList = eveBlockData.object(forKey: "reagent") as! NSArray
        var lastSubView = UIView(frame: CGRect.zero)
        let semaphore = DispatchSemaphore(value: 0)
        for subItem in subItemList {
            let subData = subItem as! NSDictionary
            let subView = self.createSubItemView(subItemData: subData, completionHandler: { (totalPrice) in
                totalPriceList.add(totalPrice!)
                if totalPriceList.count == subItemList.count {
                    semaphore.signal()
                }
            })
            blockView.addSubview(subView)
            subView.top = lastSubView.bottom
            subView.left = 0
            blockView.height = subView.bottom
            lastSubView = subView
        }
        
        semaphore.wait()
        print(totalPriceList)
        var totalPrice = Int64(0)
        for price in totalPriceList {
            totalPrice += price as! Int64
        }
        let totalPriceLabel = UILabel(frame: .zero)
        blockView.addSubview(totalPriceLabel)
        totalPriceLabel.textColor = UIColor.colorWithHex(hexValue: 0x22c12a)
        totalPriceLabel.font = UIFont.systemFont(ofSize: 12)
        if totalPrice > 0 {
            totalPriceLabel.text = "成本价:" + "\(totalPrice)".convertToGoldMoneyType()
        }
        else {
            totalPriceLabel.text = "拍卖行暂无报价"
        }
        totalPriceLabel.sizeToFit()
        totalPriceLabel.right = blockView.width - 10
        totalPriceLabel.top = lastSubView.bottom + 10
        blockView.height = totalPriceLabel.bottom + 10
        
        let line1 = createLineView(width: blockView.width, height: 0.5)
        line1.bottom = blockView.height
        line1.left = 0
        blockView.addSubview(line1)
        
        return blockView
    }
    
    private func createSubItemView(subItemData : NSDictionary, completionHandler: @escaping (Int64?) -> Swift.Void) -> UIView {
        let subItemView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 50))
        let subItemImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        subItemView.addSubview(subItemImageView)
        let url = AHCommonUtils.getImageUrl(name: subItemData["icon"] as! String, sizeType: .iTemSize56)
        subItemImageView.sd_setImage(with: url) {
            (image, error, type, url) in
            if error == nil {
                DispatchQueue.main.async {
                    subItemImageView.left = 5
                    subItemImageView.centerY = subItemView.height / 2
                }
       
            }
        }
        let subItemNameAndCountLabel = UILabel()
        let subItemCount = subItemData["count"] as! NSNumber
        subItemView.addSubview(subItemNameAndCountLabel)
        subItemNameAndCountLabel.textColor = UIColor.black
        subItemNameAndCountLabel.font = UIFont.systemFont(ofSize: 14)
        subItemNameAndCountLabel.text = "\(subItemData["name"]!) * \(subItemCount)"
        subItemNameAndCountLabel.sizeToFit()
        
        subItemNameAndCountLabel.left = 55
        subItemNameAndCountLabel.bottom = subItemView.bottom - 5
        
        let minTotalPriceLabel = UILabel()
        subItemView.addSubview(minTotalPriceLabel)
        minTotalPriceLabel.textColor = UIColor.red
        minTotalPriceLabel.font = UIFont.systemFont(ofSize: 12)
        minTotalPriceLabel.right = subItemView.width - 10
        minTotalPriceLabel.bottom = subItemNameAndCountLabel.bottom
        
        let minUnitPriceLabel = UILabel()
        subItemView.addSubview(minUnitPriceLabel)
        minUnitPriceLabel.textColor = UIColor.colorWithHex(hexValue: 0xaa0000)
        minUnitPriceLabel.font = UIFont.systemFont(ofSize: 12)
        minUnitPriceLabel.right = minTotalPriceLabel.right
        minUnitPriceLabel.bottom = minTotalPriceLabel.top - 2
        
        AHNetworkUtils.requestItemAuctionMinPrice(realm: "158", name: "\(subItemData["name"]!)") { (dic) in
            if let resultDic = dic {
                let unitPriceStr = resultDic["minPrice"] as! String
                let totalPrice = Int64(unitPriceStr)! * subItemCount.int64Value
                DispatchQueue.main.async {
                    let goldPrice = "\(totalPrice)".convertToGoldMoneyType()
                    minTotalPriceLabel.text = "总价:\(goldPrice)"
                    minTotalPriceLabel.sizeToFit()
                    minTotalPriceLabel.right = subItemView.width - 10
                    minTotalPriceLabel.bottom = subItemNameAndCountLabel.bottom
                    
                    minUnitPriceLabel.text = "单价:\(unitPriceStr.convertToGoldMoneyType())"
                    minUnitPriceLabel.sizeToFit()
                    minUnitPriceLabel.right = minTotalPriceLabel.right
                    minUnitPriceLabel.bottom = minTotalPriceLabel.top - 4
                    completionHandler(totalPrice)
                }
            }
            else {
                minTotalPriceLabel.text = "暂无价格"
                minTotalPriceLabel.sizeToFit()
                minTotalPriceLabel.right = subItemView.width - 10
                minTotalPriceLabel.bottom = subItemNameAndCountLabel.bottom
                completionHandler(0)
            }
        }
        
        return subItemView
    }
    
    private func createLineView(width: CGFloat, height: CGFloat) -> UIView {
        let lineView = UIView.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        lineView.backgroundColor = UIColor.black
        return lineView
    }
}
