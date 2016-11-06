//
//  AHFlowItemView.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/11/5.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import UIKit

@objc protocol AHFlowItemViewDelegate {
    @objc optional func didSelectedItem(flowView: AHFlowItemView, index: Int)
}

class AHFlowItemView: UIView {
    var itemsList = NSArray()
      
    weak open var  delegate : AHFlowItemViewDelegate?
    var itemTextColor : UIColor  {
        get {
            return _itemTextColor
        }
        
        set {
            _itemTextColor = newValue
            refreshWithItems(items: itemsList)
        }
    }
    private var _itemTextColor = UIColor.black
    
    var itemFont : UIFont {
        get {
            return _itemFont
        }
        
        set {
            _itemFont = newValue
            refreshWithItems(items: itemsList)
        }
    }
    private var _itemFont = UIFont.systemFont(ofSize: 11)
    

    private let buttonList = NSMutableArray()
    private let margin =  CGFloat(20)
    private let itemOffsetX = CGFloat(10)
    private let itemOffsetY = CGFloat(6)
//    private let itemStartY = CGFloat(15)
     init(frame: CGRect, items: NSArray) {
        super.init(frame: frame)
        itemsList = items
        self.backgroundColor = UIColor.clear
        refreshWithItems(items: items)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refreshWithItems(items: NSArray) {
        self.removeAllSubViews()
        self.itemsList = items
        var lastItem = UIButton(frame: CGRect(x: margin - itemOffsetX, y: 0, width: 0, height: 0))
        var index = 0
        for string in items {
            let text = string as! String
            let button = createItemButton(text: text)
            button.left = lastItem.right + itemOffsetX
            button.top = lastItem.top
            
            if button.right > self.width - margin {
                button.left = margin
                button.top = lastItem.bottom + itemOffsetY
                
            }
            
            buttonList.add(button)
            self.addSubview(button)
            button.tag = index
            lastItem = button
            index += 1
        }
        
        if lastItem.bottom > self.height {
            self.height = lastItem.bottom + itemOffsetY
        }
    }
    
    @objc private func didButtonClicked(sender: NSObject) {
        let button = sender as! UIButton
        
        delegate?.didSelectedItem!(flowView: self, index: button.tag)
    }
    
    private func createItemButton(text: String) -> UIButton {
        let button = UIButton()
        button.titleLabel?.font = itemFont
        button.setTitleColor(itemTextColor, for: .normal)
        button.setTitle(text, for: .normal)
        button.sizeToFit()
        button.width = CGFloat(text.characters.count * 11 + 26)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(didButtonClicked(sender:)), for: .touchUpInside)
        return button 
    }

}
