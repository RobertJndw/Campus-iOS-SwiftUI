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
    
    init(config: Config) {
        self.config = config
    }
    
    
    func fetch() -> Promise<[Event], APIError> {
        let promise: Promise<[Event], APIError> = config.tumCabe.doDecodableRequest(to: .eventList)
        return promise.flatMap { (events: [Event]) -> Promise<[Event], APIError> in
            return events.compactMap { (event: Event) -> Promise<Event, APIError> in
                return self.config.tumCabe.doDecodableRequest(to: .ticketTypes, arguments: ["event" : event.eventID]).map { (ticketTypes: [TicketType]) -> Event in
                    event.ticketTypes = ticketTypes
                    return event
                    }
            }.bulk
        }
    }
}
