//
//  EventTableViewCell.swift
//  Campus
//
//  Created by Tim Gymnich on 11/17/18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var availableTicketsLabel: UILabel!
    @IBOutlet var eventImageView: ShadowImageView!
    @IBOutlet weak var dateLabel: UILabel!

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
