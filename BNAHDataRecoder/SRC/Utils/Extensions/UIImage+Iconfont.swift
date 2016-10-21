//
//  UIImage+Iconfont.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/10/21.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import UIKit

extension UIImage {
    public class func imageFromIconfont(iconText: String, iconFontName: String, size: CGFloat, color: UIColor?) -> UIImage? {
        let imageSize = CGSize(width: size, height: size)
        UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.main.scale)
        let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        label.font = UIFont(name: iconFontName, size: size)
        label.text = iconText
        if color != nil {
            label.textColor = color
        }
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
    
    public class func imageFromIconfont(iconText: String, size: CGFloat, color: UIColor?) -> UIImage? {
        return UIImage.imageFromIconfont(iconText: iconText, iconFontName: "iconfont", size: size, color: color)
    }
}
