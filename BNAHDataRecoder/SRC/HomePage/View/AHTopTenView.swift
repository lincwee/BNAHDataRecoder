//
//  AHTopTenView.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/11/4.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import UIKit

class AHTopTenView: UIView, UITableViewDelegate, UITableViewDataSource {
    

    var tableView = UITableView()
    
    private var _dataList = NSArray()
    private var _showTitle = false
    private var _title = ""
    
    init(frame: CGRect, dataList: NSArray, title: String) {
        super.init(frame: frame)
        _dataList = dataList
        _showTitle = title.characters.count > 0
        _title = title
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.text = _title
        titleLabel.sizeToFit()
        self.addSubview(titleLabel)
        titleLabel.top = 0
        titleLabel.left = 10
        tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height))
        tableView.top = _showTitle ? titleLabel.bottom : 0
        tableView.height = self.height - (_showTitle ? titleLabel.height : 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .singleLineEtched
        self.addSubview(tableView)
    }

    //MARK:- UITableView delegate & dataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.height / 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let flag = "topTenViewTag"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: flag)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: flag)
        }
        cell?.textLabel?.text = "\(indexPath.row)"
        return cell!
        
    }
}
