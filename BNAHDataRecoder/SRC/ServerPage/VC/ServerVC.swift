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
    
    let kSearchCellHeight = CGFloat(40)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height - kTabbarDefaultHeight))
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
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
        )
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: flag)
        }
        cell?.textLabel?.text = "\(indexPath.row)"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kSearchCellHeight
    }
    


}
