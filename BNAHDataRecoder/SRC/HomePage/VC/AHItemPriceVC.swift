//
//  AHItemPriceVC.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/10/28.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import UIKit
import Charts

class AHItemPriceVC: UIViewController, IAxisValueFormatter {

    var chart = BarChartView()
    var dataSet: BarChartDataSet!
    let months = ["9月1日", "9月15日", "9月30日", "10月14日", "今天"]
    let lvalues: [Double] = [8, 104, 81, 93, 52, 44, 97, 101, 75, 28,
                            76, 25, 20, 13, 52, 44, 57, 23, 45, 91,
                            99, 14, 84, 48, 40, 71, 106, 41, 45, 61]
    override func viewDidLoad() {
        super.viewDidLoad()
      
//        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        
     
        
 
        
        var entries: [ChartDataEntry] = Array()
        
        for (i, value) in lvalues.enumerated()
        {
            entries.append(BarChartDataEntry(x: Double(i), y: value))
        }
        
        dataSet = BarChartDataSet(values: entries, label: "Bar chart unit test data")
        
        let data = BarChartData(dataSet: dataSet)
        data.barWidth = 0.85
        
        chart = BarChartView(frame: CGRect(x: 10, y: 70, width: kScreenW - 20, height: 230))
        chart.backgroundColor = NSUIColor.clear
        chart.leftAxis.axisMinimum = 0.0
        chart.rightAxis.axisMinimum = 0.0
        chart.chartDescription?.text = "物品价格列表"
        
        chart.data = data
        chart.xAxis.valueFormatter = self
        
//        let formato:IAxisValueFormatter = IAxisValueFormatter()
//        chart.xAxis.valueFormatter =
//        let xaxis:XAxis = XAxis()
//        chart.xAxis.valueFormatter = self
        self.view.addSubview(chart)
        
//        setChart(months, values: unitsSold)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        return months[Int(value) / (lvalues.count / months.count)]
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
