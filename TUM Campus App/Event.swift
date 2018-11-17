//
//  Event.swift
//  Campus
//
//  Created by Tim Gymnich on 11/16/18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit

class Event: DataElement, Decodable {
    
    var eventID: Int
    var news: String
    var kino: String
    var image: UIImage?
    var file: URL
    var title: String
    var description: String
    var locality: String
    var link: URL
    var start: Date
    var end: Date
    var group: String?
    var ticket: Ticket?
    
    func getCellIdentifier() -> String {
        return "EventCell"
    }
    
    var text: String {
        return self.title
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
        case event = "event"
    }
    
    required init(from decoder: Decoder) throws {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let eventString = try container.decode(String.self, forKey: .event)
        guard let eventID = Int(eventString) else {
            throw DecodingError.dataCorruptedError(forKey: .event, in: container, debugDescription: "Error parsing event")
        }
        self.eventID = eventID
        self.news = try container.decode(String.self, forKey: .news)
        self.kino = try container.decode(String.self, forKey: .kino)
        let fileURLString = try container.decode(String.self, forKey: .file).replacingOccurrences(of: " ", with: "%20")
        guard let file = URL(string: fileURLString) else {
            throw DecodingError.dataCorruptedError(forKey: .link, in: container, debugDescription: "Error parsing file url")
        }
        self.file = file
        let imageData = try? Data(contentsOf: file)
        self.image = UIImage(data: imageData ?? Data())
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.locality = try container.decode(String.self, forKey: .locality)
        let linkURLString = try container.decode(String.self, forKey: .link).replacingOccurrences(of: " ", with: "%20")
        guard let link = URL(string: linkURLString) else {
            throw DecodingError.dataCorruptedError(forKey: .link, in: container, debugDescription: "Error parsing link url")
        }
        self.link = link
        let startString = try container.decode(String.self, forKey: .start)
        guard let start = dateFormatter.date(from: startString) else {
            throw DecodingError.dataCorruptedError(forKey: .start, in: container, debugDescription: "Error parsing start date")
        }
        self.start = start
        let endString = try container.decode(String.self, forKey: .end)
        guard let end = dateFormatter.date(from: endString) else {
            throw DecodingError.dataCorruptedError(forKey: .end, in: container, debugDescription: "Error parsing end date")
        }
        self.end = end
        self.group = try? container.decode(String.self, forKey: .group)
    }
    
}
