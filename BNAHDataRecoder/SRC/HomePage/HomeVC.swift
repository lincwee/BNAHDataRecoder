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

    var buttonItem = UIButton()
    var buttonHot = UIButton()
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
