//
//  EventsTableView.swift
//  Campus
//
//  Created by Tim Gymnich on 11/17/18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit
import Sweeft

class EventsTableViewController: RefreshableTableViewController<Event>, DetailView {
    var delegate: DetailViewDelegate?
    
    override func refresh(_ sender: AnyObject?) {
        fetch(skipCache: sender != nil)?.onResult(in: .main) { result in
            self.values = result.value ?? []
            self.refresh.endRefreshing()
            
            guard sender == nil,
                let index = self.values.lastIndex(where: { $0.start > .now }) else {
                    return
            }
            let indexPath =  IndexPath(row: index, section: 0)
            self.tableView.scrollToRow(at: indexPath,
                                       at: UITableView.ScrollPosition.top,
                                       animated: false)
        }
    }
    
    override func fetch(skipCache: Bool) -> Promise<[Event], APIError>? {
        return delegate?.dataManager()?.eventManager.fetch()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if navigationTitle == nil {
            // The title has not been set during initialization of this ViewController
            navigationTitle = "Events"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as? EventTableViewCell ?? EventTableViewCell()

        let event = values[indexPath.row]
        cell.eventImageView.image = event.image ?? UIImage(named: "movie")
        cell.titleLabel.text = event.title
        if let ticket = event.ticket {
            let availableTickets = ticket.contingent - ticket.sold
            cell.availableTicketsLabel.text = "\(availableTickets) available"
        } else {
            cell.availableTicketsLabel.text = "n/a available"
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        cell.dateLabel.text = formatter.string(from: event.start)
        cell.descriptionLabel.text = event.description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        values[indexPath.row].open(sender: self)
    }
    
    
}
