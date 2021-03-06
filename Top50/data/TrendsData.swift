//
//  TrendsData.swift
//  Top50
//
//  Created by slava litskevich on 02.04.18.
//  Copyright © 2018 slava litskevich. All rights reserved.
//

import UIKit

class TrendsData: NSObject, UITableViewDataSource {
    
    let maxTopics = 50
    
    var topics: [Topic]?
    var location: Location?
    
    func reset() {
        location = nil
        topics?.removeAll()
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
