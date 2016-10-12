//
//  HomeVC.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/10/12.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    var buttomItem = UIButton()
    var buttonHot = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.buttomItem.width = self.view.width / 2
        self.buttomItem.height = 30
        self.buttonHot.width = self.buttomItem.width
        self.buttonHot.height = self.buttomItem.height
        
        self.buttomItem.left = 0;
        self.buttomItem.top = kNaviTopViewH;
        self.buttonHot.left = self.buttomItem.right
        self.buttonHot.top = self.buttomItem.top
        
        self.buttomItem.setTitle("物品查询", for: UIControlState.normal)
        self.buttomItem.setTitleColor(UIColor.black, for: UIControlState.normal)
        self.buttonHot.setTitle("其他", for: UIControlState.normal)
        self.buttonHot.setTitleColor(UIColor.gray, for: UIControlState.normal);
        
        self.view.addSubview(self.buttomItem)
        self.view.addSubview(self.buttonHot)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
