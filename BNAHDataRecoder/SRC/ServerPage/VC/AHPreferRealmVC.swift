//
//  AHPreferRealmVC.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/10/25.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import UIKit

class AHPreferRealmVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let kHeaderValue = CGFloat(50)
    var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "偏好服务器"
        
        tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height))
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
      
        self.view.backgroundColor = UIColor.colorWithHex(hexValue: 0xdddddd)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK:- UITableView delegate & dataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 1 {
            return 3
        }
        else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return getHeaderView(title: "默认服务器")
        }
        if section == 1 {
            return getHeaderView(title: "偏好服务器")
        }
        else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kHeaderValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let flag = "preferCellFlag"
        var cell = tableView.dequeueReusableCell(withIdentifier: flag)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: flag)
        }
        cell?.textLabel?.text = "\(indexPath.row)"
        return cell!
    }
    
    //MARK:- private method
    func getHeaderView(title: String) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: kHeaderValue))
        headerView.backgroundColor = UIColor.colorWithHex(hexValue: 0x63931d)
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.colorWithHex(hexValue: 0x333333)
        label.text = title
        label.sizeToFit()
        headerView.addSubview(label)
        label.centerY = headerView.height / 2
        label.left = 10
        return headerView
    }

}
