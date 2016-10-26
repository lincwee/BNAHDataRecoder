//
//  AHTabBarController.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/10/12.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import UIKit

class AHTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        let vc1 = HomeVC()
        let item1 = UITabBarItem.init(title: "首页", image: UIImage.imageFromIconfont(iconText: IconfontHot, size: 30, color: nil), tag: 0)
        vc1.tabBarItem = item1
        vc1.title = "首页"
        //first init
        self.title = "首页"
        item1.selectedImage = (UIImage.imageFromIconfont(iconText: IconfontHot, size: 30, color: nil))
        
        
        let vc2 = ServerVC()
        vc2.title = "服务器"
        let item2 = UITabBarItem.init(title: "服务器", image: UIImage.imageFromIconfont(iconText: IconfontWatchSheet, size: 30, color: nil), tag: 1)
        vc2.tabBarItem = item2
        item2.selectedImage = (UIImage.imageFromIconfont(iconText: IconfontWatchSheet, size: 30, color: nil))
        
        let vc3 = ViewController()
        vc3.title = "我的"
        let item3 = UITabBarItem.init(title: "我的", image: UIImage.imageFromIconfont(iconText: IconfontMine, size: 30, color: nil), tag: 2)
        vc3.tabBarItem = item3
        item3.selectedImage = (UIImage.imageFromIconfont(iconText: IconfontMine, size: 30, color: nil))
        
        UITabBar.appearance().tintColor = themeColor
        self.viewControllers = [vc1, vc2, vc3]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
        // Dispose of any resources that can be recreated.
    }
  
   
    
    internal func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
       let vc = self.viewControllers?[self.selectedIndex]
       self.title = vc?.title
    }
 

}
