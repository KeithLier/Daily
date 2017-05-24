//
//  Model.swift
//  ZhihuDaily
//
//  Created by keith on 2017/5/24.
//  Copyright © 2017年 keith. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String : AnyObject]

enum ParseError : Error {
    case missingAttribute(message : String)
}

protocol JSONParsable {
    static func parse(json : JSONDictionary) throws -> Self
}
