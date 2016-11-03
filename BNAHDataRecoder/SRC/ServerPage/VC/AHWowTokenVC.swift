//
//  AHWowTokenVC.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/11/3.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import UIKit
import Charts
import SVProgressHUD

class AHWowTokenVC: UIViewController, ChartViewDelegate, IAxisValueFormatter{

    private var dataList = NSArray()
    var chart = BarChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "时光徽章"
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        SVProgressHUD.show(withStatus: "正在加载...")
        AHNetworkUtils.requestWowToken { (list) in
            self.dataList = list!
            self.setCharts(list: list)
        }
        
    }
    
    private func setCharts(list: NSArray?) {
//        sortedList = list!
        DispatchQueue.main.async {
            var entries: [ChartDataEntry] = Array()
            
            for (i, value) in (list?.enumerated())!
            {
                entries.append(BarChartDataEntry(x: Double(i), y: Double((value as! NSArray).objectSafe(index: 1) as! Int64)))
            }
            
            var dataSet: BarChartDataSet!
            dataSet = BarChartDataSet(values: entries, label: "时光徽章价格")
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
            self.view.addSubview(self.chart)
            
            let lastItem = list?.lastObject as! NSArray
            let recentPrice = "\((lastItem[1] as! Int) * 10000)".convertToGoldMoneyType()
            let recentTime = AHDateHandler.dateString(timeStamp: ((lastItem[0] as! Double)/(1000)), format: "yyyy-MM-dd HH:mm:ss")
            
            let recentPriceLabel = self.createModelLabel(text: "最近价格：")
            let priceStrLabel = self.createModelLabel(text: recentPrice)
            priceStrLabel.textColor = UIColor.red
            priceStrLabel.font = UIFont.boldSystemFont(ofSize: 20)
            priceStrLabel.sizeToFit()
            self.view.addSubview(recentPriceLabel)
            self.view.addSubview(priceStrLabel)
            recentPriceLabel.left = 10
            recentPriceLabel.top = kNaviTopViewH + 13
            priceStrLabel.left = recentPriceLabel.right
            priceStrLabel.bottom = recentPriceLabel.bottom
            let recentTimeLabel = self.createModelLabel(text: "最近更新时间：" + recentTime)
            self.view.addSubview(recentTimeLabel)
            recentTimeLabel.left = recentPriceLabel.left
            recentTimeLabel.top = recentPriceLabel.bottom + 10
            
            
            self.chart.left = 0
            self.chart.top = recentTimeLabel.bottom + 10
            
            SVProgressHUD.dismiss()
        }
    }
    
    //MARK:- private method
    
    private func createModelLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.text = text
        label.sizeToFit()
        return label
    }
    
    //MARK:- charts related delegate
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        if (axis?.isEqual(self.chart.xAxis))! {
            let timeStamp = (dataList[Int(value)] as! NSArray)[0] as! Double
            return AHDateHandler.dateString(timeStamp: timeStamp / 1000, format: "MM-dd")
        }
        else {
            let strValue = "\(Int64(value) * 10000)"
            return strValue.convertToGoldMoneyType()
        }
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
