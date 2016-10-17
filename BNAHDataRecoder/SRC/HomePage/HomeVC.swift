//
//  HomeVC.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/10/12.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import UIKit
import SDWebImage

class HomeVC: UIViewController, AHRadioButtonViewDelegate {

    var buttonSearch = UIButton()
    var buttonSelectedIndex : NSInteger?
    var itemInputView = UITextField()
    var radioIdex : NSInteger = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let radioButton = AHRadioButtonView.init(frame: CGRect.init(x: 0, y: kNaviTopViewH, width: self.view.width, height: 30), itemNameList: ["物品查询", "制造材料"])
        radioButton.backgroundColor = UIColor.blue
        radioButton.delegate = self
        self.view.addSubview(radioButton)
        
        itemInputView = UITextField.init(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        itemInputView.layer.borderColor = UIColor.lightGray.cgColor
        itemInputView.layer.borderWidth = 0.5
        itemInputView.centerX = self.view.width / 2
        itemInputView.centerY = radioButton.bottom + 150
        itemInputView.placeholder = "搜索物品"
        self.view.addSubview(itemInputView)
        
        buttonSearch.width = 140
        buttonSearch.height = 30
        buttonSearch.backgroundColor = UIColor.colorWithHexStr(hexStr: "#8abd25", alpha: 1)
        buttonSearch.center = CGPoint(x: itemInputView.centerX, y: itemInputView.bottom + 70)
        buttonSearch.setTitle("搜索", for: .normal)
        buttonSearch.addTarget(self, action: #selector(onSearchClicked(button:)), for: .touchUpInside)
        self.view.addSubview(buttonSearch)
    }
    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onSearchClicked(button : UIButton!) -> Void {
//        itemInputView.resignFirstResponder()
        let value = itemInputView.text! as String
        if value.characters.count == 0 {
            return
        }
     
        if radioIdex == 0 {
            AHNetworkUtils.requestAuctionItem(realm: "158", name: value) { (listData) in
                print(listData?.objectSafe(index: 0))
            }
        }
        else {
            AHNetworkUtils.requestItem(realm: "158", name: value, completionHandler: { (dicData) in
                print(dicData!["icon"]!)
                
            })
        }
    }
    
    func didSelectedIndex(index: NSInteger) {
        radioIdex = index
        let placeHolder = index == 0 ? "搜索物品" : "搜索制造物品的材料"
        itemInputView.placeholder = placeHolder
    }
}
