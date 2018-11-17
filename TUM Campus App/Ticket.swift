//
//  Ticket.swift
//  Campus
//
//  Created by Tim Gymnich on 11/17/18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import Foundation

class Ticket: Decodable {
    var ticketType: Int
    var contingent: Int
    var sold: Int
    
    enum CodingKeys: String, CodingKey {
        case ticketType = "ticket_type"
        case contingent = "contingent"
        case sold = "sold"
    }
    
    required init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let object = try container.nestedContainer(keyedBy: CodingKeys.self)
        let ticketTypeString = try object.decode(String.self, forKey: .ticketType)
        guard let ticketType = Int(ticketTypeString) else {
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.ticketType, in: object, debugDescription: "Error decoding ticket type")
        }
        self.ticketType = ticketType
        let contingentString = try object.decode(String.self, forKey: .contingent)
        guard let contingent = Int(contingentString) else {
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.contingent, in: object, debugDescription: "Error decoding contingent")
        }
        self.contingent = contingent
        let soldString = try object.decode(String.self, forKey: .sold)
        guard let sold = Int(soldString) else {
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.sold, in: object, debugDescription: "Error decoding sold")
        }
        self.sold = sold
    }
    
}
