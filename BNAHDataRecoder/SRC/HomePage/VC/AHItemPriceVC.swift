//
//  AHItemPriceVC.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/10/28.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import UIKit
import Charts
import SVProgressHUD

let kChartsHeight = CGFloat(230)
let kChartsViewHeight = kChartsHeight + 5
let kItemDetailHeaderHeight = CGFloat(100)

class AHItemPriceVC: UIViewController,
    IAxisValueFormatter,
    ChartViewDelegate,
    UITableViewDelegate,
UITableViewDataSource {

    var chart = BarChartView()
    var sortedList = NSArray()
    let itemDetailView = UIView()
    var pastItemList = NSArray()
    let tableView = UITableView()
    let rightTableView = UITableView()
    let rightItemView = UIView()
    let rightItemShadowView = UIView()
    
    var isShowCharts = false
    var isShowRightView = false
    
    private let kTableViewHeaderHeight = CGFloat(30)
    private let kRightTableViewHeaderHeight = CGFloat(25)
    
    private var _itemName = ""
    private var _realmName = AHCommonUtils.defaultRealmName
    
    init(itemName: String) {
        _itemName = itemName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "历史价格"
        tableView.frame = self.view.frame
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tag = 0
        self.view.addSubview(tableView)
        self.view.backgroundColor = UIColor.colorWithHex(hexValue: 0xddddddd)
//        AHRealmHelper.deleteAll()
        AHRealmHelper.addHistory(itemName: _itemName)
        initDetailView()
        refreshNavibarView()
        initLeftView()
        refreshAuctionData()
    }
    
    //MARK:- data feature
    
    private func refreshAuctionData() {
        SVProgressHUD.show(withStatus: "正在加载...")
        let dicRealm = AHCommonUtils.getRealmData(name: _realmName!)

        let id = dicRealm?["id"] as! Int
        
        AHNetworkUtils.requestItemPastData(name: self._itemName, realmId: "\(id)") { (list) in
            self.pastItemList = list!
            //                            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet.init(integer: 2), with: .automatic)
            }
            AHNetworkUtils.requestItemHistoryData(name: self._itemName, realmId: "\(id)"){ (list) in
                let sortedList = list?.sorted(by: { (it1, it2) -> Bool in
                    let timeStamp1 =  (it1 as! NSArray).objectSafe(index: 2) as! Int64
                    let timeStamp2 = (it2 as! NSArray).objectSafe(index: 2) as! Int64
                    return timeStamp1 < timeStamp2
                })
                self.setCharts(list: sortedList as NSArray?)
                SVProgressHUD.dismiss()
                
            }
        }
    }

    private func refreshNavibarView() {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.titleLabel?.textColor = UIColor.white
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        let str = "服务器:\n" + _realmName!
        let nsStr = str as NSString
        
        let attStr = NSMutableAttributedString.init(string: str)
        attStr.addAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 12),
                              NSForegroundColorAttributeName : UIColor.white],
                             range: nsStr.range(of: "服务器:"))
        attStr.addAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 14),
                              NSForegroundColorAttributeName : UIColor.colorWithHex(hexValue: 0xdc544b)],
                             range: nsStr.range(of: _realmName!))
        button.setAttributedTitle(attStr, for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(didRightButtonClicked), for: .touchUpInside)
        
        let rightItem = UIBarButtonItem.init(customView: button)
        
     
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    private func initLeftView() {
        rightTableView.frame = CGRect(x: 0, y: kNaviTopViewH, width: 200, height: kScreenH - kNaviTopViewH)
        rightTableView.alpha = 0.8
        rightTableView.backgroundColor = UIColor.colorWithHex(hexValue: 0xaaaaaa)
        rightTableView.left = kScreenW
        rightTableView.tag = 1
        rightTableView.delegate = self
        rightTableView.dataSource = self
        rightTableView.bounces = false
        
        rightItemShadowView.frame = self.tableView.frame
        rightItemShadowView.backgroundColor = UIColor.colorWithHex(hexValue: 0x000000, alpha: 0.8)
        self.view.addSubview(rightItemShadowView)
//        rightItemShadowView.isHidden = true
        rightItemShadowView.alpha = 0
        rightItemShadowView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(didRightButtonClicked)))
        
        self.view.addSubview(rightTableView)
        rightTableView.bringSubview(toFront: tableView)
    }
    
    private func initDetailView() {
        itemDetailView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kItemDetailHeaderHeight)
        itemDetailView.backgroundColor = UIColor.colorWithHex(hexValue: 0xeeeeeee)
        
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 20)
        nameLabel.textColor = UIColor.black
        nameLabel.text = _itemName
        nameLabel.sizeToFit()
        nameLabel.left = 100
        nameLabel.top = 10
        itemDetailView.addSubview(nameLabel)
        let desLabel = UILabel(frame: CGRect(x: nameLabel.left, y: nameLabel.bottom + 5, width: self.itemDetailView.width - 110, height: kItemDetailHeaderHeight - 45))
        self.itemDetailView.addSubview(desLabel)
        desLabel.numberOfLines = 0
        desLabel.font = UIFont.systemFont(ofSize: 14)
        desLabel.textColor = UIColor.lightGray
        desLabel.text = "加载中..."
        
        let iconImage = UIImageView.init(frame: CGRect(x: 10, y: 10, width: 67, height: 67))
        iconImage.image = UIImage(named: kAHImageDefault)
        self.itemDetailView.addSubview(iconImage)
        
        AHNetworkUtils.requestItemFromBattleNet(name: _itemName) { (dic) in
            let iconStr = dic?["icon"] as! String
            let descriptionStr = dic?["description"] as! String
            
            DispatchQueue.main.async {
                desLabel.text = descriptionStr.characters.count == 0 ? "暂无详情" : descriptionStr
                iconImage.sd_setImage(with: AHCommonUtils.getImageUrl(name: iconStr, sizeType: .iTemSize56), placeholderImage: UIImage(named: kAHImageDefault))
                
            }
        }
    }

    
    private func setCharts(list: NSArray?) {
        sortedList = list!
        DispatchQueue.main.async {
            var entries: [ChartDataEntry] = Array()
            
            for (i, value) in (list?.enumerated())!
            {
                entries.append(BarChartDataEntry(x: Double(i), y: Double((value as! NSArray).objectSafe(index: 0) as! Int64) / 10000))
            }
            
            var dataSet: BarChartDataSet!
            dataSet = BarChartDataSet(values: entries, label: "当时段平均价格")
            dataSet.colors = [themeColor]
            dataSet.highlightColor = UIColor.purple
            
            let data = BarChartData(dataSet: dataSet)
            data.barWidth = 0.85
//            data.setDrawValues(false)
     
            self.chart = BarChartView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kChartsHeight))
            self.chart.leftAxis.axisMinimum = 0.0
            self.chart.rightAxis.axisMinimum = 0.0
            self.chart.chartDescription?.text = ""
            self.chart.scaleYEnabled = false
            
            self.chart.data = data
            
            self.chart.delegate = self
            self.chart.xAxis.valueFormatter = self
            self.chart.leftAxis.valueFormatter = self
            self.chart.rightAxis.enabled = false
        }
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        if (axis?.isEqual(self.chart.xAxis))! {
            let timeStamp = (sortedList[Int(value)] as! NSArray)[2] as! Double
            return AHDateHandler.dateString(timeStamp: timeStamp / 1000, format: "MM-dd")
        }
        else {
            let strValue = "\(Int64(value) * 10000)"
            return strValue.convertToGoldMoneyType()
        }
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
    }
    
    //MARK:- private method
    func headerSelected() {
        isShowCharts = !isShowCharts
//        self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
        self.tableView.reloadSections(IndexSet.init(integer: 1), with: .automatic)
    }
    
    
    func didRightButtonClicked() {
        
        
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            if self.isShowRightView {
                self.rightTableView.left = kScreenW
                self.rightItemShadowView.alpha = 0
            }
            else {
                self.rightTableView.right = kScreenW
                self.rightItemShadowView.alpha = 1
            }
        }, completion: {(finished) -> Void in
//            self.rightItemShadowView.isHidden = self.isShowRightView
            self.isShowRightView = !self.isShowRightView
        })
    }

    //MARK:- UITableViewDelegate && DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == 0 {
            return 3
        }
        else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView.tag == 1 {
            let view = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kRightTableViewHeaderHeight))
            view.backgroundColor = UIColor.lightGray
            let textLabel = UILabel()
            textLabel.textColor = UIColor.white
            textLabel.font = UIFont.boldSystemFont(ofSize: 12)
            textLabel.text = section == 0 ? "默认服务器" : "偏好服务器"
            textLabel.sizeToFit()
            textLabel.centerY = view.height / 2
            textLabel.left = 10
            view.addSubview(textLabel)
            return view
        }
        
        
        if section == 1 {
            let view = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kTableViewHeaderHeight))
            view.backgroundColor = UIColor.colorWithHex(hexValue: 0x2f89cc)
            view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(headerSelected)))
            let textLabel = UILabel()
            textLabel.textColor = UIColor.white
            textLabel.font = UIFont.boldSystemFont(ofSize: 14)
            textLabel.text = "价格趋势图"
            textLabel.sizeToFit()
            textLabel.centerY = view.height / 2
            textLabel.left = 10
            view.addSubview(textLabel)
            
            let isShowFlagLabel = UILabel()
            isShowFlagLabel.textColor = UIColor.white
            isShowFlagLabel.font = UIFont.systemFont(ofSize: 12)
            isShowFlagLabel.text = isShowCharts ? "隐藏" : "展示"
            isShowFlagLabel.sizeToFit()
            isShowFlagLabel.centerY = view.height / 2
            isShowFlagLabel.right = kScreenW - 10
            view.addSubview(isShowFlagLabel)
            return view
        }
        else if section == 2 {
            let view = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kTableViewHeaderHeight))
            view.backgroundColor = UIColor.purple
            let textLabel = UILabel()
            textLabel.textColor = UIColor.white
            textLabel.font = UIFont.boldSystemFont(ofSize: 14)
            textLabel.text = "价格列表"
            textLabel.sizeToFit()
            textLabel.centerY = view.height / 2
            textLabel.left = 10
            view.addSubview(textLabel)
            return view
        }
        else if section == 0 {
//            view.backgroundColor = UIColor.colorWithHex(hexValue: 0xeeeeeee)
            return itemDetailView
        }
        else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.tag == 0 {
            if section == 1 || section == 2 {
                return kTableViewHeaderHeight
            }
            else {
                return kItemDetailHeaderHeight
            }
        }
        else {
            return kRightTableViewHeaderHeight
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 0 {
            if indexPath.section == 1 && indexPath.row == 0 {
                return isShowCharts ? kChartsViewHeight : 0
            }
            else {
                return 40
            }
        }
        else {
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            if section == 1 {
                return 1
            }
            else if section == 2 {
                return pastItemList.count
            }
            else {
                return 0
            }
        }
        else {
            if section == 0 {
                return 1
            }
            else {
                return (AHCommonUtils.preferRealm?.count)!
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //tag == 1
        if tableView.tag == 1 {
            let flag = "rightItemFlag"
            var cell = tableView.dequeueReusableCell(withIdentifier: flag)
            if cell == nil {
                cell = UITableViewCell.init(style: .default, reuseIdentifier: flag)
                cell?.backgroundColor = UIColor.gray
                cell?.textLabel?.textColor = UIColor.white
                cell?.tintColor = UIColor.white
            }
            if indexPath.section == 0 {
                cell?.textLabel?.text = AHCommonUtils.defaultRealmName
                cell?.accessoryType = AHCommonUtils.defaultRealmName == _realmName ? .checkmark : .none
            }
            else {
                let str = AHCommonUtils.preferRealm?[indexPath.row] as! String
                cell?.textLabel?.text = str
                cell?.accessoryType = str == _realmName ? .checkmark : .none
            }
            return cell!
        }
        
        // tag == 0
        if indexPath.section == 1 {
            if self.isShowCharts {
                let firstFlag = "fistSection"
                let cell = UITableViewCell.init(style: .default, reuseIdentifier: firstFlag)
                self.chart.removeFromSuperview()
                self.chart.animate(yAxisDuration: 1)
                self.chart.left = 0
                self.chart.bottom = kChartsViewHeight
                cell.addSubview(self.chart)
                return cell
            }
            else {
                return UITableViewCell()
            }
        }
        else if indexPath.section == 2 {
            let flag = "itemPriceFlag"
            var cell = tableView.dequeueReusableCell(withIdentifier: flag)
            if cell == nil {
                cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: flag)
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
                cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
                cell?.detailTextLabel?.textColor = UIColor.colorWithHex(hexValue: 0x777777)
            }
            cell?.textLabel?.text = "\(((pastItemList[indexPath.row] as! NSArray)[0]))".convertToGoldMoneyType()
            cell?.detailTextLabel?.text = "数量:" + "\(((pastItemList[indexPath.row] as! NSArray)[1]))"
            return cell!
        }
        else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView.tag == 1 {
            let cell = tableView.cellForRow(at: indexPath)
            let selectName = "\((cell?.textLabel?.text)!)"
            _realmName = selectName
            rightTableView.reloadData()
            didRightButtonClicked()
            refreshNavibarView()
            refreshAuctionData()
            
        }
    }
}
