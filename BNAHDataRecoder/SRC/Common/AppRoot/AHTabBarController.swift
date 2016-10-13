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
        vc1.title = "首页"
        
        let vc2 = ViewController()
        vc2.title = "vc2"
        
        let vc3 = ViewController()
        vc3.title = "vc3"
        
        let vc4 = ViewController()
        vc4.title = "vc4"
        
        self.viewControllers = [vc1, vc2, vc3, vc4]
        
        self.title = vc1.title

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
   
    
    internal func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
       var vc = self.viewControllers?[self.selectedIndex]
       self.title = vc?.title
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
