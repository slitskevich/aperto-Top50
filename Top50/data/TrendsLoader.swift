//
//  TrendsLoader.swift
//  Top50
//
//  Created by slava litskevich on 03.04.18.
//  Copyright © 2018 slava litskevich. All rights reserved.
//

import Foundation

class TrendsLoader {
    
    let trendsData: TrendsData
    
    init(trendsData: TrendsData) {
        self.trendsData = trendsData
    }
    
    func reload(handler: @escaping ((Error?) -> ())) {
        trendsData.reset()
        loadLocation() {[weak self](location: Location?, error: Error?) in
            self?.trendsData.location = location
            if let currentLocation = location {
                self?.loadTrends(locationId: currentLocation.locationId) {(topics: [Topic]?, error: Error?) in
                    self?.trendsData.topics = topics
                    handler(error)
                }
            } else {
                handler(error)
            }
        }
    }
    
    func loadLocation(loadHandler: @escaping ((Location?, Error?) -> ())) {
        LocationService().getGeoLocation(handler: loadHandler)
    }
    
    func loadTrends(locationId: String, loadHandler: @escaping (([Topic]?, Error?) -> ())) {
        TrendsService().loadTrends(locationId: locationId, handler: loadHandler)
    }
    
}
