//
//  News.swift
//  ZhihuDaily
//
//  Created by keith on 2017/5/24.
//  Copyright © 2017年 keith. All rights reserved.
//

import Foundation

struct News {
    var dateString : String
    var stories : [Story]
    var topStories : [Story]?
    
    var beautifulDate : String {
        let str = dateString as NSString
        let year = str.substring(to: 4)
        let month = (str.substring(from: 4) as NSString).substring(to: 2)
        let day = str.substring(from: 6)
        return year + "年" + month + "月" + day + "日"
    }
    
    init(dateString: String, stories: [Story], topStories: [Story]?) {
        self.dateString = dateString
        self.stories = stories
        self.topStories = topStories
    }
}

extension News {
    
    static var latestNewsURL : URL {
        return URL(string: "https://news-at.zhihu.com/api/4/news/latest")!
    }
    
    var previousNewsURL : URL {
        return URL(string: "https://news-at.zhihu.com/api/4/news/before/\(dateString)")!
    }
}

extension News : JSONParsable {
    
    static func parse(json: JSONDictionary) throws -> News {
        
        guard let dateString = json["date"] as? String else {
            let message = "Expected date String"
            throw ParseError.missingAttribute(message: message)
        }
        
        guard let storyDicts = json["stories"] as? [JSONDictionary] else {
            let message = "Expected stories String"
            throw ParseError.missingAttribute(message: message)
        }
        
        var topStories: [Story]?
        if let topStoriesDicts = json["top_stories"] as? [JSONDictionary] {
            topStories = try topStoriesDicts.map{ (json) -> Story in
                return try Story.parse(json: json)
            }
        }
        
        let stories = try storyDicts.map{ (json) -> Story in
            return try Story.parse(json: json)
        }
        
        return News(dateString: dateString, stories: stories, topStories: topStories)
    }
}
