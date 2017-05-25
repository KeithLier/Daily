//
//  Story.swift
//  ZhihuDaily
//
//  Created by keith on 2017/5/24.
//  Copyright © 2017年 keith. All rights reserved.
//

import UIKit

struct Story {
    var id: Int
    var title: String
    var thumbnail: String
    
    var storyURL: String {
        return "https://news-at.zhihu.com/api/4/news/\(id)"
    }
    
    var thumbnailURL: URL {
        return URL(string: thumbnail)!
    }
    
    init(id: Int, title: String, thumbnail: String) {
        self.id = id
        self.title = title
        self.thumbnail = thumbnail
    }
}

extension Story: JSONParsable {
    static func parse(json: JSONDictionary) throws -> Story {
        
        guard let id = json["id"] as? Int else {
            throw ParseError.missingAttribute(message: "Expected id Int")
        }

        guard let title = json["title"] as? String else {
            throw ParseError.missingAttribute(message: "Expected stories String")
        }
        
        guard let thumbnailURL = (json["images"] as? [String])?.first ?? json["image"] as? String else {
            throw ParseError.missingAttribute(message: "Expected image Url")
        }
        
        return Story(id: id, title: title, thumbnail: thumbnailURL)
    }
}
