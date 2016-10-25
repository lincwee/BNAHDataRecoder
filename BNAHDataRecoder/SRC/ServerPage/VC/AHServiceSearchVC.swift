//
//  AHServiceSearchVC.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/10/23.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import UIKit
import SCLAlertView

protocol AHServiceSearchVCDelegate {
    
}

class AHServiceSearchVC: UISearchController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {

    var tableViewVC : UITableViewController = UITableViewController()
    var realmData : NSArray! = AHCommonUtils.realmList
    var filterRealmData : NSArray = []
    
    init() {
        super.init(searchResultsController: UITableViewController())
        filterRealmData = NSMutableArray(array: realmData)
        self.searchBar.setValue("取消", forKey: "_cancelButtonText")
        self.searchBar.tintColor = UIColor.black
        self.searchBar.placeholder = "请输入服务器名称"
        self.searchBar.delegate = self
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchResultsUpdater = self
        self.delegate = self
        tableViewVC = self.searchResultsController as! UITableViewController
        
        tableViewVC.tableView.delegate = self
        tableViewVC.tableView.dataSource = self
        
     

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// MARK:- UITableView delegate & datasource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        return filterRealmData.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let flag = "ahServiceFlag"
        var cell = tableView.dequeueReusableCell(withIdentifier: flag)
        if cell == nil {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: flag)
        }
        let cellListItem = filterRealmData[indexPath.row] as! NSDictionary
        let defaultServetItem = AHCommonUtils.defaultRealm
        var text = cellListItem.object(forKey: "name")! as! String
        if cellListItem.isEqual(defaultServetItem) {
            text += "(默认服务器)"
            cell?.textLabel?.textColor = UIColor.red
        }
        else {
            cell?.textLabel?.textColor = UIColor.black
        }
        cell?.textLabel?.text = text
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let serverData = filterRealmData.objectSafe(index: indexPath.row) as! NSDictionary
        self.searchBar.resignFirstResponder()
        let alert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
        alert.addButton("查看服务器详情") {
            self.isActive = false
        }

        alert.addButton("添加偏好服务器") {
            self.isActive = false
        }
        
        alert.addButton("设置为默认服务器") {
            self.isActive = false
            let dic = self.realmData.objectSafe(index: indexPath.row) as! NSDictionary
            AHCommonUtils.defaultRealm = dic
            tableView.reloadData()
        }
        
        alert.addButton("取消") { 
            alert.hideView()
            self.searchBar.becomeFirstResponder()
        }
        
        alert.showTitle("", subTitle: "服务器:"+"\(serverData["name"]!)", style: .notice, closeButtonTitle: "取消", duration: 0, colorStyle: UInt(themeColorHexValue), colorTextButton: 0xffffff, circleIconImage: nil, animationStyle: .topToBottom)
    }
  

    
    //MARK:- UISearchController delegate
    
    func updateSearchResults(for searchController: UISearchController) {
        print(searchBar.text!)
        if searchBar.text?.characters.count == 0 {
            DispatchQueue.main.async {
                self.searchResultsController?.view.isHidden = false
            }
        }
        filterRealmKeyword(keyword: searchBar.text!)
    }

    
    //MARK:- private method
    private func filterRealmKeyword(keyword : String) {
        filterRealmData = []
        if keyword == "" {
            filterRealmData = realmData
        }
        else {
            let mutableList = NSMutableArray()
            for item in realmData {
                let itemDic = item as! NSDictionary
                if "\(itemDic["name"]!)".components(separatedBy: keyword).count > 1 {
                    mutableList.add(item)
                }
            }
            filterRealmData = mutableList
        }
        tableViewVC.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }
}
