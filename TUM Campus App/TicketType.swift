//
//  TicketType.swift
//  Campus
//
//  Created by Tim Gymnich on 11/17/18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import Foundation

class TicketType: Decodable, DataElement {
    /// Ticket Price in cents
    var price: Int
    var contingent: Int
    var sold: Int
    var description: String
    var payment: Payment
    var available: Int { return contingent - sold }
    
    var text: String {
        return description
    }
    
    func getCellIdentifier() -> String {
        return "TicketTypeCell"
    }

    enum CodingKeys: String, CodingKey {
        case price = "price"
        case contingent = "contingent"
        case sold = "sold"
        case description = "description"
        case payment = "payment"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let priceString = try container.decode(String.self, forKey: .price)
        guard let price = Int(priceString) else {
            throw DecodingError.dataCorruptedError(forKey: .price, in: container, debugDescription: "Error decoding price")
        }
        self.price = price
        let contingentString = try container.decode(String.self, forKey: .contingent)
        guard let contingent = Int(contingentString) else {
            throw DecodingError.dataCorruptedError(forKey: .contingent, in: container, debugDescription: "Error decoding contingent")
        }
        self.contingent = contingent
        let soldString = try container.decode(String.self, forKey: .sold)
        guard let sold = Int(soldString) else {
            throw DecodingError.dataCorruptedError(forKey: .sold, in: container, debugDescription: "Error decoding sold")
        }
        self.sold = sold
        self.description = try container.decode(String.self, forKey: .description)
        self.payment = try container.decode(Payment.self, forKey: .payment)
    }
    
}

class Payment: Decodable {
    var stripeKey: String
    var terms: URL
    var minTickets: Int
    var maxTickets: Int
    
    enum CodingKeys: String, CodingKey {
        case stripeKey = "stripe_publishable_key"
        case terms = "terms"
        case minTickets = "minTickets"
        case maxTickets = "maxTickets"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.stripeKey = try container.decode(String.self, forKey: .stripeKey)
        self.terms = try container.decode(URL.self, forKey: .terms)
        let minTicketsString = try container.decode(String.self, forKey: .minTickets)
        guard let minTickets = Int(minTicketsString) else {
            throw DecodingError.dataCorruptedError(forKey: .minTickets, in: container, debugDescription: "Error decoding minTickets")
        }
        self.minTickets = minTickets
        let maxTicketsString = try container.decode(String.self, forKey: .maxTickets)
        guard let maxTickets = Int(maxTicketsString) else {
            throw DecodingError.dataCorruptedError(forKey: .maxTickets, in: container, debugDescription: "Error decoding maxTickets")
        }
        self.maxTickets = maxTickets
    }
}
