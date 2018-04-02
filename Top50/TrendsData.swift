//
//  TrendsData.swift
//  Top50
//
//  Created by slava litskevich on 02.04.18.
//  Copyright © 2018 slava litskevich. All rights reserved.
//

import UIKit

class TrendsData: NSObject, UITableViewDataSource {
    
    let twitterService = TwitterService()
    let locationService = LocationService()
    
    let maxTopics = 50
    
    var topics: [Topic]?
    
    func reload(handler: @escaping ((NSError?) -> ())) {
        locationService.getCurrentLocation() {(locationId: String?, error: Error?) in
            if let currentLocation = locationId {
                self.twitterService.loadTrends(locationId: currentLocation) {(topics: [Topic]?, error: NSError?) in
                    self.topics = topics
                    handler(error)
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics != nil ? min(maxTopics, topics!.count) : 0
    }
    
    let CELL_ID = "TopicCell"
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: CELL_ID)
        }
        cell!.textLabel?.text = topics![indexPath.row].name
        return cell!
    }
    
}
