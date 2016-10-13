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
    
    var ItemNameList : NSArray?
    var buttonList : NSArray?

    public init(frame: CGRect, itemNameList: NSArray) {
        super.init(frame: frame)
        self.ItemNameList = itemNameList
        self.backgroundColor = UIColor.purple
        initButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initButton() {
        let count = CGFloat((ItemNameList?.count)!)
        let buttonW = self.width / count
        var index = 0 as CGFloat
        for name in ItemNameList! {
            let button = UIButton.init(frame: CGRect(x: index * buttonW, y: 0, width: buttonW, height: self.height))
            button.setTitle(name as? String, for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.setTitleColor(UIColor.gray, for: .highlighted)
            button.setTitleColor(UIColor.gray, for: .selected)
            button.setTitleColor(UIColor.gray, for: .disabled)
            self.addSubview(button)
            index += 1
        }
    }
}
