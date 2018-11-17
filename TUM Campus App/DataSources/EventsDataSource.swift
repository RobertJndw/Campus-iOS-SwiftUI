
//
//  File.swift
//  Campus
//
//  Created by Tim Gymnich on 11/16/18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit

class EventsDataSource: NSObject, TUMDataSource, TUMInteractiveDataSource {
    var manager: EventManager
    let parent: CardViewController
    var cellType: AnyClass = EventCollectionViewCell.self
    var isEmpty: Bool { return events.isEmpty }
    var cardKey: CardKey = .event
    var preferredHeight: CGFloat = 360.0
    lazy var flowLayoutDelegate: ColumnsFlowLayoutDelegate = FixedColumnsFlowLayoutDelegate(delegate: self)
    var events: [Event] = []
    
    init(parent: CardViewController, manager: EventManager) {
        self.parent = parent
        self.manager = manager
        super.init()
    }
    
    func refresh(group: DispatchGroup) {
        group.enter()
        manager.fetch().onSuccess(in: .main) { data in
            self.events = data
            group.leave()
            }.onError { error in
            print("error: \(error)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellReuseID, for: indexPath) as! EventCollectionViewCell

        let event = events[indexPath.row]
        
        cell.typeLabel.text = "TU FILM"
        cell.titleLabel.text = event.title
        cell.descriptionLable.text = event.description
        cell.imageView.image = event.image ?? UIImage(named: "movie")
        
        return cell
    }
    
    @objc func onItemSelected(at indexPath: IndexPath) {
        let event = events[indexPath.row]
        let storyboard = UIStoryboard(name: "Event", bundle: nil)
        if let destination = storyboard.instantiateInitialViewController() as? EventTableViewController {
            destination.event = event
            destination.delegate = parent
            parent.navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    @objc func onShowMore() {
        let storyboard = UIStoryboard(name: "Events", bundle: nil)
        if let destination = storyboard.instantiateInitialViewController() as? EventsTableViewController {
            destination.delegate = parent
            destination.values = events
            destination.navigationTitle = "Events"
            parent.navigationController?.pushViewController(destination, animated: true)
        }
    }
    

}
