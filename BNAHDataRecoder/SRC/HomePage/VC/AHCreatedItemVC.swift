//
//  AHCreatedItemVC.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/10/17.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import UIKit

class AHCreatedItemVC: UIViewController {
    
    var createdItemData : NSDictionary = [:]
    var scrollView = UIScrollView()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.colorWithHex(hexValue: 0xdddddd)
        
        scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height))
        self.view.addSubview(scrollView)
        
        let subItemView = AHCreatedSubItemsView.init(subItemData: createdItemData)
        scrollView.contentSize = CGSize(width: scrollView.width, height: subItemView.height)
        scrollView.addSubview(subItemView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
