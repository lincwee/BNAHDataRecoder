//
//  HomeVC.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/10/12.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, AHRadioButtonViewDelegate {

    var buttonItem = UIButton()
    var buttonHot = UIButton()
    var buttonSelectedIndex : NSInteger?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let radioButton = AHRadioButtonView.init(frame: CGRect.init(x: 0, y: kNaviTopViewH, width: self.view.width, height: 30), itemNameList: ["物品查询", "其他"])
        radioButton.delegate = self
        self.view .addSubview(radioButton)
       // initButton()
        
    }
    
    func initButton() {
        buttonItem.width = self.view.width / 2
        buttonItem.height = 30
        buttonHot.width = self.buttonItem.width
        buttonHot.height = self.buttonItem.height
        buttonItem.tag = 0
        buttonHot.tag = 1
        
        buttonItem.left = 0;
        buttonItem.top = kNaviTopViewH;
        buttonHot.left = self.buttonItem.right
        buttonHot.top = self.buttonItem.top
        buttonItem.isSelected = true
        
        buttonItem.setTitle("物品查询", for: .normal)
        buttonHot.setTitle("其他", for: .normal)
        
        buttonItem.setTitleColor(UIColor.black, for: .normal)
        buttonItem.setTitleColor(UIColor.gray, for: .highlighted)
        buttonItem.setTitleColor(UIColor.gray, for: .selected)
        buttonItem.setTitleColor(UIColor.gray, for: .disabled)
        buttonHot.setTitleColor(UIColor.black, for: .normal);
        buttonHot.setTitleColor(UIColor.gray, for: .highlighted)
        buttonHot.setTitleColor(UIColor.gray, for: .selected)
        buttonHot.setTitleColor(UIColor.gray, for: .disabled)
        
        buttonHot.addTarget(self, action: #selector(onButtonClicked(button:)), for: .touchUpInside)
        buttonItem.addTarget(self, action: #selector(onButtonClicked(button:)), for: .touchUpInside)
        
        view.addSubview(self.buttonItem)
        view.addSubview(self.buttonHot)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onButtonClicked(button : UIButton!) -> Void {
     
        buttonSelectedIndex = button.tag
        buttonItem.isSelected = button.tag == 0
        buttonHot.isSelected = button.tag == 1
        if button.tag == 0 {
            print("===========0");
        }
        else if button.tag == 1 {
            print("===========1");
        }
        else {
            
        }
    }
    
    func didSelectedIndex(index: NSInteger) {
        print(index)
    }
}
