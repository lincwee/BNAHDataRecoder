//
//  AHRealmDetailCell.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/10/26.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import UIKit

class AHRealmDetailCell: UITableViewCell {

    public static var cellHeight = CGFloat(120)
    
    private let leftMargin = CGFloat(10)
    private let rightMargin = CGFloat(10)
    private let topMargin = CGFloat(5)
    
    let labelType = UILabel()
    let labelName = UILabel()
    let labelAuctionQuantity = UILabel()
    let labelPlayerQuantity = UILabel()
    let labelItemQuantity = UILabel()
    let labelUpdateTime = UILabel()
    
    var _realmData = NSDictionary()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        self.selectionStyle = .none
        
        self.addSubview(labelType)
        labelType.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(labelName)
        labelName.font = UIFont.boldSystemFont(ofSize: 20)
        self.addSubview(labelAuctionQuantity)
        labelAuctionQuantity.font = UIFont.systemFont(ofSize: 16)
        self.addSubview(labelPlayerQuantity)
        labelPlayerQuantity.font = UIFont.systemFont(ofSize: 16)
        self.addSubview(labelItemQuantity)
        labelItemQuantity.font = UIFont.systemFont(ofSize: 16)
        self.addSubview(labelUpdateTime)
        labelUpdateTime.font = UIFont.systemFont(ofSize: 12)
        labelUpdateTime.textColor = UIColor.lightGray
        
        let bottomLine = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 0.5))
        self.addSubview(bottomLine)
        bottomLine.backgroundColor = UIColor.lightGray
        bottomLine.bottom = AHRealmDetailCell.cellHeight
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setRealmData(realmData : NSDictionary) {
        _realmData = realmData
        let realmNativeData = AHCommonUtils.getRealmData(id: (_realmData["id"] as! Int))
        
        labelName.text = realmNativeData?["name"]! as! String?
        labelName.sizeToFit()
        
        labelType.text = _realmData["type"] as? String
        labelType.textColor = labelType.text == "pvp" ? UIColor.red : UIColor.colorWithHex(hexValue: 0x5fda53)
        labelType.sizeToFit()
        
        labelAuctionQuantity.text = "拍卖总数:" + "\(_realmData["auctionQuantity"]!)"
        labelAuctionQuantity.sizeToFit()
        
        labelItemQuantity.text = "物品总类:" + "\(_realmData["itemQuantity"]!)"
        labelItemQuantity.sizeToFit()
        
        labelPlayerQuantity.text = "玩家总数:" + "\(_realmData["playerQuantity"]!)"
        labelPlayerQuantity.sizeToFit()
        
        labelUpdateTime.text = "2016-10-29"
        labelUpdateTime.sizeToFit()
        
        resetLabelPos()
        
    }
    
    private func resetLabelPos() {
        labelName.left = leftMargin
        labelName.top = topMargin
        
        labelType.left = labelName.left
        labelType.top = labelName.bottom + 10
        
        labelPlayerQuantity.bottom = labelName.bottom
        labelPlayerQuantity.right = kScreenW - rightMargin
        
        labelAuctionQuantity.top = labelPlayerQuantity.bottom + 10
        labelAuctionQuantity.right = labelPlayerQuantity.right
        
        labelItemQuantity.top = labelAuctionQuantity.bottom + 10
        labelItemQuantity.right = labelAuctionQuantity.right
        
        labelUpdateTime.right = labelItemQuantity.right
        labelUpdateTime.bottom = AHRealmDetailCell.cellHeight - 5
        
    }
    

}
