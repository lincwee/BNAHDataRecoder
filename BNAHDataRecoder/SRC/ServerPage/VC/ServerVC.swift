//
//  ServerVC.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/10/23.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import UIKit

class ServerVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var tableView = UITableView()
    var searchVC : AHServiceSearchVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height - kTabbarDefaultHeight))
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateDefaultRealm), name: NSNotification.Name.init(rawValue: kNotificationDefaultRealmChanged), object: nil)
        
        searchVC = AHServiceSearchVC()
        self.tableView.tableHeaderView = searchVC.searchBar
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //UITableView delegate & datasource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        return 3
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let flag = "serverSearchFlag"
        var cell = tableView.dequeueReusableCell(withIdentifier: flag
        ) as?
        AHServerItemCell
        if cell == nil {
            cell = AHServerItemCell.init(style: .default, reuseIdentifier: flag)
        }
        if indexPath.row == 0 {
            cell?.setCellData(data: ["title": "默认服务器", "subTitle": "\((AHCommonUtils.defaultRealm?.object(forKey: "name"))!)"])
        }
        else if indexPath.row == 1 {
            cell?.setCellData(data: ["title": "偏好服务器"])
        }
        else {
            cell?.setCellData(data: ["title": "时光徽章"])
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AHServerItemCell.cellHeight
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.row == 0 {
            searchVC.isActive = true
        }
    }
    
    //MARK:- private method
    @objc private func updateDefaultRealm() {
        tableView.reloadData()
    }

}
