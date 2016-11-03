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
    var realmSummaryData = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.navigationBar.isTranslucent = true
        
        let rootView = UIView.init(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        self.view.addSubview(rootView)
        
        tableView = UITableView.init(frame: CGRect(x: 0, y: kNaviTopViewH, width: self.view.width, height: self.view.height - kTabbarDefaultHeight))
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        let refreshControl = UIRefreshControl.init()
        refreshControl.attributedTitle = NSAttributedString.init(string: "刷新服务器数据...")
        refreshControl.addTarget(self, action: #selector(refreshing), for: .valueChanged)
        tableView.refreshControl = refreshControl
        self.view.addSubview(tableView)

        searchVC = AHServiceSearchVC()
        self.tableView.tableHeaderView = searchVC.searchBar

        initNotification()
        requestRealmSummaryData()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
            cell?.accessoryType = .none
        }
        else if indexPath.row == 1 {
            cell?.setCellData(data: ["title": "偏好服务器"])
            cell?.accessoryType = .disclosureIndicator
        }
        else {
            cell?.setCellData(data: ["title": "时光徽章"])
            cell?.accessoryType = .disclosureIndicator
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
        if indexPath.row == 1 {
            DispatchQueue.main.async {
                let preferRealmVC = AHPreferRealmVC()
                preferRealmVC.realmSummaryList = self.realmSummaryData
                self.navigationController?.pushViewController(preferRealmVC, animated: true)
            }
        }
        
        if indexPath.row == 2 {
            DispatchQueue.main.async {
                let wowTokenVC = AHWowTokenVC()
                self.navigationController?.pushViewController(wowTokenVC, animated: true)
            }
        }
    }
    
    //MARK:- private method
    @objc private func updateDefaultRealm() {
        tableView.reloadData()
    }
    
    @objc private func refreshing() {
        AHNetworkUtils.requestRealmsSummary { (list) in
            if (list?.count)! > 0 {
                self.realmSummaryData = list!
            }
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    private func requestRealmSummaryData() {
        AHNetworkUtils.requestRealmsSummary { (list) in
            if (list?.count)! > 0 {
                self.realmSummaryData = list!
            }
        }
    }
    
    private func initNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateDefaultRealm), name: NSNotification.Name.init(rawValue: kNotificationDefaultRealmChanged), object: nil)
    }

}
