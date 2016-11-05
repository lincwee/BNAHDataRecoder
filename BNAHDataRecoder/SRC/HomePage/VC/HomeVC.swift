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

class HomeVC: UIViewController, AHRadioButtonViewDelegate, AHAutoCompleteTextFieldViewDelegate {

    var buttonSearch = UIButton()
    var buttonSelectedIndex : NSInteger?
    var itemInputView = AHAutoCompleteTextFieldView()
    var radioIdex : NSInteger = 0
    var topTenSearchView = UIView()
    var topTenHotView = UIView()
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
        
        let radioButton = AHRadioButtonView.init(frame: CGRect.init(x: 0, y: kNaviTopViewH, width: self.view.width, height: 40), itemNameList: ["物品查询", "制造材料"])
        radioButton.backgroundColor = UIColor.colorWithHex(hexValue: 0xdddddd)
        radioButton.selectedBackgroundColor = UIColor.white
        
        radioButton.delegate = self
        self.view.addSubview(radioButton)
        
        let inputViewW = kScreenW / 3 * 2
        itemInputView = AHAutoCompleteTextFieldView.init(frame: CGRect(x: 0, y: 0, width: inputViewW, height: 30))
        itemInputView.textField.backgroundColor = UIColor.colorWithHex(hexValue: 0xdddddd)
        itemInputView.left = 15
        itemInputView.top = radioButton.bottom + 20
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
        
//        let rect = CGRect(x: 0, y: 0, width: self.view.width / 2, height: 300)
//        topTenSearchView = AHTopTenView.init(frame: rect, dataList: [1,2,3,4,5,6,7,8,9,0], title: "热门物品")
//        topTenSearchView.top = buttonSearch.bottom + 20
//        topTenSearchView.left = 0
//        self.view.addSubview(topTenSearchView)
        
//        let rect1 = CGRect(x: 0, y: 0, width: self.view.width / 2, height: 300)
//        topTenHotView = AHTopTenView.init(frame: rect1, dataList: [1,2,3,4,5,6,7,8,9,0], title: "搜索历史")
//        topTenHotView.top = topTenSearchView.top
//        topTenHotView.left = topTenSearchView.right
//        self.view.addSubview(topTenHotView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
                self.title = "价格查询"
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
    
    // AHRadioButtonViewDelegate
    func didSelectedIndex(index: NSInteger) {
        radioIdex = index
        let placeHolder = index == 0 ? kSearchItemPlaceplaceholderStr : kCreatedMetplaceholderStr
        itemInputView.textField.placeholder = placeHolder
    }
    
    // AHAutoCompleteTextFieldViewDelegate
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
}
