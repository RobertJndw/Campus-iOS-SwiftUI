
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
    //         VariableColumnsFlowLayoutDelegate(aspectRatio: CGFloat(2.0/3.0), delegate: self)
    lazy var flowLayoutDelegate: ColumnsFlowLayoutDelegate = FixedColumnsFlowLayoutDelegate()
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
    

}
