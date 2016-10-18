//
//  AHCommonUtils.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/10/18.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import UIKit

enum AHItemImageSizeType {
    case itemSize18
    case itemSize36
    case iTemSize56
}


class AHCommonUtils: NSObject {
    public class func getImageUrl(name : String, sizeType : AHItemImageSizeType) -> URL {
        var size = String()
        switch sizeType {
        case .itemSize18:
            size = "18"
            break
        case .itemSize36:
            size = "36"
            break
        case .iTemSize56 :
            size = "56"
            break
        }
        
        let urlStr = "http://content.battlenet.com.cn/wow/icons/\(size)/\(name).jpg"
        return URL(string: urlStr)!
    }
}
