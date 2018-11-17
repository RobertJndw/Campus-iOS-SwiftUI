//
//  EventViewController.swift
//  Campus
//
//  Created by Tim Gymnich on 11/17/18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit


class EventTableViewController: UITableViewController {
    @IBOutlet var eventImageView: ShadowImageView!
    @IBOutlet var titleLabel: UILabel!
    
    var event: Event?
    
    override func viewDidLoad() {
        if let event = event {
            eventImageView.image = event.image ?? UIImage(named: "moview")
            titleLabel.text = event.title
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return event?.ticketTypes.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TicketTypeCell") as? TicketTypeCell ?? TicketTypeCell()
        guard let ticketType = event?.ticketTypes[indexPath.row] else {
            return cell
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencySymbol = "€"
        cell.contingentLabel.text = "\(ticketType.available) available"
        cell.descriptionLabel.text = ticketType.description
        cell.priceLabel.text = numberFormatter.string(from: NSNumber(value: Double(ticketType.price)/100.0))
        
        return cell
    }
    

}
