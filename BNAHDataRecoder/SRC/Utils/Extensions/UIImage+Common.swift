//
//  UIImage+Common.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/10/20.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import UIKit

extension UIImage {
    
    //image from color
    
    class func imageFromColor(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let Image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
       
        return Image
    }
}
