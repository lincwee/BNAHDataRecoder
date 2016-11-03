//
//  AHAutoCompleteTextFieldView.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/10/19.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import UIKit

let kAutoCompleteViewDefaultHeight = CGFloat(135)
let kAutoCompleteCellHeight = CGFloat(30)

protocol AHAutoCompleteTextFieldViewDelegate{
    func textDidChange(textFieldView: AHAutoCompleteTextFieldView, text: String)
    
    func autoTextShouldReturn(textFieldView: AHAutoCompleteTextFieldView, text: String)
}

class AHAutoCompleteTextFieldView: UIView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    //propertey
    let textField = UITextField()
    var autoCompleteView = UITableView()
    var delegate : AHAutoCompleteTextFieldViewDelegate?
    
    private var _listACData : NSArray = []
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        textField.frame = frame
        textField.backgroundColor = UIColor.lightGray
        textField.delegate = self
        //textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange), name: Notification.Name.UITextFieldTextDidChange, object: nil)
        self.addSubview(textField)
        self.initAutoCompleteView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setAutoCompleteData(dataList: NSArray?) {
        _listACData = dataList!
        self.resetAutoCompleteView(inputStr: textField.text!)
        autoCompleteView.reloadData()
        if autoCompleteView.contentSize.height < kAutoCompleteViewDefaultHeight {
            autoCompleteView.height = autoCompleteView.contentSize.height
            autoCompleteView.isScrollEnabled = false
        }
        else {
            autoCompleteView.height = kAutoCompleteViewDefaultHeight
            autoCompleteView.isScrollEnabled = true
        }
    }
    private func initAutoCompleteView() {
        autoCompleteView = UITableView.init(frame: CGRect(x: 0, y: 0, width: self.width, height: kAutoCompleteViewDefaultHeight))
        autoCompleteView.backgroundColor = UIColor.colorWithHex(hexValue: 0xeeeeee)
        autoCompleteView.delegate = self
        autoCompleteView.dataSource = self
        autoCompleteView.layer.borderColor = UIColor.colorWithHex(hexValue: 0x222222).cgColor
        autoCompleteView.layer.borderWidth = 0.5
        autoCompleteView.bounces = false
    }
    
    private func resetAutoCompleteView(inputStr: String) {
        if autoCompleteView.superview == nil {
            self.superview?.addSubview(autoCompleteView)
        }
        if inputStr.characters.count == 0 {
            autoCompleteView.isHidden = true
            return
        }
        else {
            autoCompleteView.isHidden = false
        }
        autoCompleteView.top = self.bottom
        autoCompleteView.left = self.left
    }
    
    func textFieldDidChange() {
        let textRange = textField.markedTextRange
        //只有在无高亮的情况下才进行text change判断
        if textRange == nil {
            print(textField.text!)
            delegate?.textDidChange(textFieldView: self, text: textField.text!)
        }
    }
    
    //UITableViewDelegate
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _listACData.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseId = "autoViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseId)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: reuseId)
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 12)
        }
        cell?.textLabel?.text = _listACData.objectSafe(index: indexPath.row) as? String
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kAutoCompleteCellHeight
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        textField.text = _listACData.objectSafe(index: indexPath.row) as? String
        autoCompleteView.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.autoTextShouldReturn(textFieldView: self, text: textField.text!)
        return false
    }

}
