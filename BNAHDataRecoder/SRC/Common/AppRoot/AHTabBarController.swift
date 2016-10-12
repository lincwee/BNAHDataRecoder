//
//  AHTabBarController.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/10/12.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import UIKit

class AHTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let vc1 = HomeVC()
        vc1.title = "首页"
        let nc1 = UINavigationController(rootViewController: vc1)
        
        let vc2 = ViewController()
        vc2.title = "vc2"
        let nc2 = UINavigationController(rootViewController: vc2)
        
        let vc3 = ViewController()
        vc3.title = "vc3"
        let nc3 = UINavigationController(rootViewController: vc3)
        
        let vc4 = ViewController()
        vc4.title = "vc4"
        let nc4 = UINavigationController(rootViewController: vc4)
        
        self.viewControllers = [nc1, nc2, nc3, nc4]

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
