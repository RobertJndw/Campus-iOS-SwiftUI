//
//  MovieTicketManager.swift
//  Campus
//
//  Created by Tim Gymnich on 11/16/18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import Foundation
import Sweeft

final class EventManager: SingleItemManager, CardManager {
    typealias DataType = Event
    
    var requiresLogin: Bool = true
    var cardKey: CardKey = .event
    var config: Config
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return dateFormatter
    }()
    
    init(config: Config) {
        self.config = config
    }
    
    func fetch() -> Promise<[Event], APIError> {
        return config.tumCabe.doDecodableRequest(to: .eventList, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy.formatted(dateFormatter))
    }

}
