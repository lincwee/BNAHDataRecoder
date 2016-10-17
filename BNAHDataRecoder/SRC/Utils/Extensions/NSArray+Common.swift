//
//  NSArray+Common.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/10/17.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import UIKit

extension NSArray {
    public func objectSafe(index: Int) -> Any? {
        if self.count <= index {
            return nil
        }
        return self.object(at: index)
    }
}
