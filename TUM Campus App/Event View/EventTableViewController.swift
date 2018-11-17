//
//  EventViewController.swift
//  Campus
//
//  Created by Tim Gymnich on 11/17/18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit


class EventTableViewController: RefreshableTableViewController<TicketType>, DetailView {
    @IBOutlet weak var eventImageView: ShadowImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var delegate: DetailViewDelegate?
    var event: Event? {
        didSet {
            self
        }
    }
    

}
