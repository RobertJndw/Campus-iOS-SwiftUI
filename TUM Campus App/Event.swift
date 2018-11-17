//
//  Event.swift
//  Campus
//
//  Created by Tim Gymnich on 11/16/18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import Foundation

class Event: DataElement, Decodable {
    
    var news: String
    var kino: String
    var file: String
    var title: String
    var description: String
    var locality: String
    var link: String
    var start: String
    var end: String
    var group: String?
    
    func getCellIdentifier() -> String {
        return "EventCell"
    }
    
    var text: String {
        return ""
    }
    
    enum CodingKeys: String, CodingKey {
        case news = "news"
        case kino = "kino"
        case file = "file"
        case title = "title"
        case description = "description"
        case locality = "locality"
        case link = "link"
        case start = "start"
        case end = "end"
        case group = "ticket_group"
    }
    
    init(decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.news = try container.decode(String.self, forKey: .news)
        self.kino = try container.decode(String.self, forKey: .kino)
        self.file = try container.decode(String.self, forKey: .file)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.locality = try container.decode(String.self, forKey: .locality)
        self.link = try container.decode(String.self, forKey: .link)
        self.start = try container.decode(String.self, forKey: .start)
        self.end = try container.decode(String.self, forKey: .end)
        self.group = try container.decode(String.self, forKey: .group)
    }
    
}
