//
//  AHRadioButtonView.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/10/13.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import UIKit

protocol AHRadioButtonViewDelegate {
    func didSelectedIndex(index: NSInteger)
}

class AHRadioButtonView: UIView {
    
    private var _itemNameList : NSArray = []
    public var ItemNameList : NSArray{
        set {
            _itemNameList = newValue
            initButton()
        }
        
        get {
            return _itemNameList
        }
    }
    
    public var selectedItemColor : UIColor = UIColor.black
    public var disSelecteddisableItemColor : UIColor = UIColor.gray
    
    var buttonList = NSMutableArray()
    var delegate: AHRadioButtonViewDelegate?
    
    
    public init(frame: CGRect, itemNameList: NSArray) {
        super.init(frame: frame)
        ItemNameList = itemNameList
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initButton() {
        self.removeAllSubViews()
        
        let count = CGFloat((ItemNameList.count))
        let buttonW = self.width / count
        var index = 0
        for name in ItemNameList {
            let startX = CGFloat(index)*buttonW
            let button = UIButton.init(frame: CGRect(x: startX, y: 0, width: buttonW, height: self.height))
            button.setTitle(name as? String, for: .normal)
            button.setTitleColor(selectedItemColor, for: .normal)
            button.setTitleColor(disSelecteddisableItemColor, for: .highlighted)
            button.setTitleColor(disSelecteddisableItemColor, for: .selected)
            button.setTitleColor(disSelecteddisableItemColor, for: .disabled)
            button.addTarget(self, action: #selector(onItemClicked(button:)), for: .touchUpInside)
            button.tag = index
            self.addSubview(button)
            buttonList.add(button)
            index += 1
        }
        //default index = 0 button selected
        let buttonFirst = buttonList[0] as! UIButton
        onItemClicked(button: buttonFirst)
    }
    
    func onItemClicked(button: UIButton!) {
        for i in 0..<buttonList.count {
            let enButton = buttonList[i]  as! UIButton
            if enButton.tag == button.tag {
                enButton.isEnabled = false
            }
            else {
                enButton.isEnabled = true
            }
        }
 
        delegate?.didSelectedIndex(index: button.tag)
    }
}
