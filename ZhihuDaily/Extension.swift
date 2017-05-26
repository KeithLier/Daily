//
//  Extension.swift
//  ZhihuDaily
//
//  Created by keith on 2017/5/26.
//  Copyright © 2017年 keith. All rights reserved.
//

import UIKit


extension String {
    
    func getHeight(givenWidth: CGFloat, font: UIFont) -> CGFloat {
        let text = self as NSString
        let attributes = [NSFontAttributeName: font]
        
        let rect = text.boundingRect(with: CGSize(width: givenWidth, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return rect.height
    }
}
