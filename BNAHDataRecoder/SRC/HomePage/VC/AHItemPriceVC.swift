//
//  AHItemPriceVC.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/10/28.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import UIKit
import Charts

class AHItemPriceVC: UIViewController, IAxisValueFormatter, ChartViewDelegate {

    var chart = BarChartView()
    var sortedList = NSArray()
    private var _itemName = ""
    
    init(itemName: String) {
        _itemName = itemName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.colorWithHex(hexValue: 0xddddddd)
      
        AHNetworkUtils.requestItemHistoryData(name: _itemName, realmId: "158"){ (list) in
            let sortedList = list?.sorted(by: { (it1, it2) -> Bool in
                let timeStamp1 =  (it1 as! NSArray).objectSafe(index: 2) as! Int64
                let timeStamp2 = (it2 as! NSArray).objectSafe(index: 2) as! Int64
                return timeStamp1 < timeStamp2
            })
            self.setCharts(list: sortedList as NSArray?)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
     
            self.chart = BarChartView(frame: CGRect(x: 0, y: 100, width: kScreenW, height: 230))
            self.chart.leftAxis.axisMinimum = 0.0
            self.chart.rightAxis.axisMinimum = 0.0
            self.chart.chartDescription?.text = "物品价格列表"
            self.chart.scaleYEnabled = false
            
            self.chart.data = data
            
            self.chart.delegate = self
            self.chart.xAxis.valueFormatter = self
            self.chart.leftAxis.valueFormatter = self
            self.chart.rightAxis.enabled = false
            self.view.addSubview(self.chart)
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
//        return months[Int(value) / (lvalues.count / months.count)]
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
