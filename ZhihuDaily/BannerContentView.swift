//
//  BannerContentView.swift
//  ZhihuDaily
//
//  Created by keith on 2017/5/26.
//  Copyright © 2017年 keith. All rights reserved.
//

import UIKit
import Alamofire

class BannerContentView: UIView {
    
    var imageView = UIImageView()
    var label = UILabel()
    var labelMargin: CGFloat = 8
    
    var dataSource: BannerDataSource!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupImageView()
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
}

extension BannerContentView {
    
    func setupImageView() {
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.frame = frame
        
        addSubview(imageView)
    }
    
    func setupLabel() {
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = Theme.white
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        addSubview(label)
    }
}

extension BannerContentView {
    
    func configureModel(model: BannerDataSource) {
        self.dataSource = model
        
        imageView.af_setImage(withURL: model.bannerImageURL!)
        
        let height = model.bannerTitle.getHeight(givenWidth: UIScreen.main.bounds.width - labelMargin * 2, font: label.font)
        label.frame = CGRect(origin: CGPoint(x: labelMargin, y: frame.height - height - 37), size: CGSize(width: UIScreen.main.bounds.width - labelMargin * 2, height: height))
        label.text = model.bannerTitle        
    }
}
