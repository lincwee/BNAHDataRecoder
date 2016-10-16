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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let radioButton = AHRadioButtonView.init(frame: CGRect.init(x: 0, y: kNaviTopViewH, width: self.view.width, height: 30), itemNameList: ["物品查询", "其他"])
        radioButton.backgroundColor = UIColor.blue
        radioButton.delegate = self
        self.view.addSubview(radioButton)
        
        let itemInputView = UITextField.init(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        itemInputView.layer.borderColor = UIColor.lightGray.cgColor
        itemInputView.layer.borderWidth = 0.5
        itemInputView.centerX = self.view.width / 2
        itemInputView.centerY = radioButton.bottom + 150
        self.view.addSubview(itemInputView)
        
        buttonSearch.width = 140
        buttonSearch.height = 30
        buttonSearch.backgroundColor = UIColor.colorWithHexStr(hexStr: "#8abd25", alpha: 1)
        buttonSearch.center = CGPoint(x: itemInputView.centerX, y: itemInputView.bottom + 70)
        buttonSearch.setTitle("搜索", for: .normal)
        self.view.addSubview(buttonSearch)
    }
    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onSearchClicked(button : UIButton!) -> Void {
    
    }
    
    func didSelectedIndex(index: NSInteger) {
        print(index)
    }
}
