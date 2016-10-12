//
//  UIView+Layout.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/10/12.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import UIKit

extension UIView {
    var left : CGFloat {
        set {
            if left == newValue {
                return;
            }
            self.frame.origin.x = newValue;
        }
        get {
            return self.frame.origin.x;
        }
    };
    
    var top : CGFloat {
        set {
            if top == newValue {
                return;
            }
            self.frame.origin.y = newValue;
        }
        
        get {
            return self.frame.origin.y;
        }
    }
    
    var right : CGFloat {
        set {
            if right == newValue {
                return;
            }
            self.frame.origin.x = newValue - self.width;
        }
        
        get {
            return self.left + self.width;
        }
    }
    
    var bottom : CGFloat {
        set {
            if bottom == newValue {
                return;
            }
            self.frame.origin.y = newValue - self.height;
        }
        
        get {
            return self.top + self.height;
        }
    }
    
    var centerX : CGFloat {
        set {
            self.center.x = newValue;
        }
        
        get {
            return self.center.x;
        }
    }
    
    var centerY : CGFloat {
        set {
            self.center.y = newValue;
        }
        
        get {
            return self.center.y;
        }
    }
    
    
    var width : CGFloat {
        set {
            self.frame.size.width = newValue;
        }
        
        get {
            return self.frame.size.width;
        }
    }
    
    var height : CGFloat {
        set {
            self.frame.size.height = newValue;
        }
        
        get {
            return self.frame.size.height;
        }
    }
    
    var origin : CGPoint {
        set {
            self.frame.origin = newValue;
        }
        
        get {
            return self.frame.origin;
        }
    }
    
    var size : CGSize {
        set {
            self.frame.size = newValue;
        }
        
        get {
            return self.frame.size;
        }
    }
    
    
    
}
