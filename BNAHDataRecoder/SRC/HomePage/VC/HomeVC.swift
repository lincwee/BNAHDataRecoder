//
//  HomeVC.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/10/12.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

class HomeVC: UIViewController, AHRadioButtonViewDelegate, AHAutoCompleteTextFieldViewDelegate, AHFlowItemViewDelegate {

    var buttonSearch = UIButton()
    var buttonSelectedIndex : NSInteger?
    var itemInputView = AHAutoCompleteTextFieldView()
    var radioIdex : NSInteger = 0
    var topTenSearchView = UIView()
    var topTenHotView = UIView()
    var hotItemView = UIScrollView()
    var topRadioButtonView : AHRadioButtonView?
    var hotTypeRadioButtonView : AHRadioButtonView?
    var floatItemView : AHFlowItemView?
    
    private var hotItemMouthList = NSMutableArray()
    private var hotItemWeekList = NSMutableArray()
    private var hotItemDayList = NSMutableArray()
    
    var hotItemDic = NSDictionary()
    
    var historyList : NSArray {
        get {
            let historyData = AHRealmHelper.realm(ofType: AHHistorySearchItem.self)
            let mList = NSMutableArray()
            let maxItem = 10
            var tag = 0
            for item in historyData! {
                if tag < maxItem {
                    let itemName = (item as! AHHistorySearchItem).name
                    mList.add(itemName)
                    tag += 1
                }
                else {
                    break
                }
            }
            return mList
        }
    }
    
    let kSearchItemPlaceplaceholderStr = "搜索物品"
    let kCreatedMetplaceholderStr = "搜索制造物品的材料"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "首页"
        self.view.backgroundColor = UIColor.white
        SVProgressHUD.setDefaultMaskType(.black)
        
        topRadioButtonView = AHRadioButtonView.init(frame: CGRect.init(x: 0, y: kNaviTopViewH, width: self.view.width, height: 40), itemNameList: ["物品查询", "制造材料"])
        topRadioButtonView?.backgroundColor = UIColor.colorWithHex(hexValue: 0xdddddd)
        topRadioButtonView?.selectedBackgroundColor = UIColor.white
        topRadioButtonView?.disSelecteddisableItemColor = UIColor.colorWithHex(hexValue: 0x333333)
        
        topRadioButtonView?.delegate = self
        self.view.addSubview(topRadioButtonView!)
        
        let inputViewW = kScreenW / 3 * 2
        itemInputView = AHAutoCompleteTextFieldView.init(frame: CGRect(x: 0, y: 0, width: inputViewW, height: 30))
        itemInputView.textField.backgroundColor = UIColor.colorWithHex(hexValue: 0xdddddd)
        itemInputView.left = 15
        itemInputView.top = (topRadioButtonView?.bottom)! + 20
        itemInputView.delegate = self
        itemInputView.textField.placeholder = kSearchItemPlaceplaceholderStr
        itemInputView.textField.returnKeyType = .search
        self.view.addSubview(itemInputView)
        
        buttonSearch.width = kScreenW - inputViewW - 30
        buttonSearch.height = itemInputView.height
        buttonSearch.backgroundColor = UIColor.colorWithHexStr(hexStr: "#8abd25", alpha: 1)
        buttonSearch.setBackgroundImage(UIImage.imageFromColor(color: UIColor.colorWithHex(hexValue: 0xaaaaaa)), for: .disabled)
        buttonSearch.left = itemInputView.right
        buttonSearch.top = itemInputView.top
        buttonSearch.setTitle("搜索", for: .normal)
        buttonSearch.addTarget(self, action: #selector(onSearchClicked(button:)), for: .touchUpInside)
        self.view.addSubview(buttonSearch)
        buttonSearch.isEnabled = false

        initHotItemsView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func initHotItemsView() {
        let hotItemViewTop = buttonSearch.bottom + 30
        hotItemView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height - hotItemViewTop)
        self.view.addSubview(hotItemView)
        hotItemView.backgroundColor = UIColor.colorWithHex(hexValue: 0xe0e0e0)
        hotItemView.top = hotItemViewTop
        
        //type radio button
        hotTypeRadioButtonView = AHRadioButtonView.init(frame: CGRect.init(x: 0, y: 10, width: self.view.width / 2, height: 15), itemNameList: ["每月", "每周","每天"])
        hotTypeRadioButtonView?.backgroundColor = UIColor.clear
        hotTypeRadioButtonView?.selectedBackgroundColor = UIColor.clear
        hotItemView.addSubview(hotTypeRadioButtonView!)
        hotTypeRadioButtonView?.delegate = self
        hotTypeRadioButtonView?.textFont = UIFont.systemFont(ofSize: 12)
        hotTypeRadioButtonView?.disSelecteddisableItemColor = themeColor
        hotTypeRadioButtonView?.right = hotItemView.width - 10
        
        // hot image
        let hotImageView = UIImageView(image: UIImage.imageFromIconfont(iconText: IconfontHot, size: 20, color: UIColor.red))
        hotItemView.addSubview(hotImageView)
        hotImageView.left = 10
        hotImageView.centerY = (hotTypeRadioButtonView?.centerY)!
        
        let labelHot = UILabel()
        labelHot.font = UIFont.systemFont(ofSize: 15)
        labelHot.textColor = UIColor.red
        labelHot.text = "热门物品"
        labelHot.sizeToFit()
        hotItemView.addSubview(labelHot)
        labelHot.left = hotImageView.right + 5
        labelHot.centerY = hotImageView.centerY
        
        self.floatItemView = AHFlowItemView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 90),
                                            items: [])
        self.hotItemView.addSubview(self.floatItemView!)
        self.floatItemView?.delegate = self
        self.floatItemView?.top = (self.hotTypeRadioButtonView?.bottom)! + 13
        
        AHNetworkUtils.requestHotItems { (list) in
            if let dataList = list {
                self.hotItemMouthList = NSMutableArray(array: dataList.subarray(with: NSRange.init(location: 0, length: 10)))
                self.hotItemWeekList = NSMutableArray(array: dataList.subarray(with: NSRange.init(location: 10, length: 10)))
                self.hotItemDayList = NSMutableArray(array: dataList.subarray(with: NSRange.init(location: 20, length: 10)))

                self.hotFloatViewRefresh(index: 0)
            }
        }
    }
    
    private func hotFloatViewRefresh(index: Int) {
        let hotNameList = NSMutableArray(capacity: 10)
        var targetList = NSArray()
        switch index {
        case 0:
            targetList = self.hotItemMouthList
        case 1:
            targetList = self.hotItemWeekList
        case 2:
            targetList = self.hotItemDayList
        default:
            targetList = self.hotItemMouthList
        }
        for item in targetList {
            let dicItem = item as! NSDictionary
            let name = dicItem["name"] as! String
            hotNameList.add(name)
        }
        DispatchQueue.main.async {
            self.floatItemView?.refreshWithItems(items: hotNameList)
        }
    }
    
    func onSearchClicked(button : UIButton!) -> Void {

        itemInputView.textField.resignFirstResponder()
        let value = itemInputView.textField.text! as String
//        let pinyinValue = value.applyingTransform(.toLatin, reverse: false)
//        print(pinyinValue!)
        if value.characters.count == 0 {
            return
        }
        if radioIdex == 0 {
            DispatchQueue.main.async {
                let itemPriceVC = AHItemPriceVC(itemName: value)
                self.title = "首页"
                self.navigationController?.pushViewController(itemPriceVC, animated: true)
            }
            return
        }
        else {
            SVProgressHUD.show(withStatus: "正在加载")
            AHNetworkUtils.requestItem(name: value, completionHandler: { (dicData) in
                SVProgressHUD.dismiss()
                if dicData ==  nil {
                    return
                }
                DispatchQueue.main.async {
                    let newVC = AHCreatedItemVC()
                    newVC.createdItemData = dicData!
                    newVC.title = "制造物品详情"
                    self.navigationController!.pushViewController(newVC, animated: true)
                }
            })
        }
    }
    
    //MARK:- AHRadioButtonViewDelegate
    func didSelectedIndex(radioButtonView: AHRadioButtonView,index: NSInteger) {
        if radioButtonView == topRadioButtonView  {
            radioIdex = index
            let placeHolder = index == 0 ? kSearchItemPlaceplaceholderStr : kCreatedMetplaceholderStr
            itemInputView.textField.placeholder = placeHolder
        }
        
        if radioButtonView == hotTypeRadioButtonView {
               self.hotFloatViewRefresh(index: index)
        }
    }
    
    //MARK:- AHAutoCompleteTextFieldViewDelegate
    func textDidChange(textFieldView: AHAutoCompleteTextFieldView, text: String, isAutoComplete: Bool) {
        let isHasText = text.characters.count > 0
        buttonSearch.isEnabled = isHasText
        //if is auto complete
        if isAutoComplete {
            return
        }
        
        //if not auto, just about text is or not
        if isHasText {
            AHNetworkUtils.requestGetItemNames(name: text) { (data) in
                DispatchQueue.main.async {
                    if let dataList = data {
                        self.itemInputView.setAutoCompleteData(dataList: dataList)
                        self.itemInputView.textStyle = .defaultStyle
                    }
                    else {
                        self.itemInputView.setAutoCompleteData(dataList: [])
                    }
                }
            }
        }
        else {
            // load self search word
            self.itemInputView.setAutoCompleteData(dataList: historyList)
            self.itemInputView.textStyle = .lightBlueStyle
        }
    }
    
    func autoTextShouldReturn(textFieldView: AHAutoCompleteTextFieldView, text: String) {
        onSearchClicked(button: nil)
    }
    
    func autoTextDidEdit(edit: Bool, text: String) {
        if text.characters.count > 0 {
            AHNetworkUtils.requestGetItemNames(name: text) { (data) in
                DispatchQueue.main.async {
                    if let dataList = data {
                        self.itemInputView.setAutoCompleteData(dataList: dataList)
                        self.itemInputView.textStyle = .defaultStyle
                    }
                    else {
                        self.itemInputView.setAutoCompleteData(dataList: [])
                    }
                }
            }
        }
        else {
            if edit {
                self.itemInputView.setAutoCompleteData(dataList: historyList)
                self.itemInputView.textStyle = .lightBlueStyle
            }
            else {
                self.itemInputView.setAutoCompleteData(dataList: [])
                self.itemInputView.textStyle = .lightBlueStyle
            }
        }
    }
    
    //MARK:- AHFlowItemViewDelegate
    
    func didSelectedItem(flowView: AHFlowItemView, index: Int) {
        let name = flowView.itemsList[index] as! String
        self.itemInputView.textField.text = name
        self.textDidChange(textFieldView: self.itemInputView, text: name, isAutoComplete: false)
    }
}
