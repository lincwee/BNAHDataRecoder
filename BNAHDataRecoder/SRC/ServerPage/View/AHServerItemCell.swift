//
//  AHServerItemCell.swift
//  BNAHDataRecoder
//
//  Created by 郝 林巍 on 2016/10/24.
//  Copyright © 2016年 lincwee. All rights reserved.
//

import UIKit

class AHServerItemCell: UITableViewCell {

    static let cellHeight = CGFloat(55)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    let centerView = UIView()
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        subTitleLabel.font = UIFont.systemFont(ofSize: 14)
        subTitleLabel.textColor = UIColor.lightGray
        
        centerView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: AHServerItemCell.cellHeight)
        self.contentView.addSubview(centerView)
        centerView.addSubview(titleLabel)
        centerView.addSubview(subTitleLabel)
        let bottomLine = UIView(frame: CGRect(x: 0, y: 0, width: centerView.width - 20, height: 0.5))
        bottomLine.bottom = centerView.height
        bottomLine.backgroundColor = UIColor.black
        centerView.addSubview(bottomLine)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setCellData(data: NSDictionary) {
        let titleStr = data["title"] as? String
        let subtitleStr = data["subTitle"] as? String
        
        if titleStr != nil {
            titleLabel.text = titleStr
            titleLabel.sizeToFit()
            titleLabel.centerY = AHServerItemCell.cellHeight / 2
            titleLabel.left = 10
        }
        
        if subtitleStr != nil {
            subTitleLabel.text = subtitleStr
            subTitleLabel.sizeToFit()
            
            subTitleLabel.centerY = AHServerItemCell.cellHeight / 2
            subTitleLabel.right = kScreenW - 20
        }
    }

}
