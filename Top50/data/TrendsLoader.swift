//
//  TrendsLoader.swift
//  Top50
//
//  Created by slava litskevich on 03.04.18.
//  Copyright © 2018 slava litskevich. All rights reserved.
//

import Foundation

class TrendsLoader {
    
    let twitterService = TrendsService()
    let locationService = LocationService()

    let trendsData: TrendsData
    
    init(trendsData: TrendsData) {
        self.trendsData = trendsData
    }
    
    func reload(handler: @escaping ((Error?) -> ())) {
        trendsData.reset()
        locationService.getGeoLocation() {[weak self](location: Location?, error: Error?) in
            self?.trendsData.location = location
            if let currentLocation = location {
                self?.twitterService.loadTrends(locationId: currentLocation.locationId) {(topics: [Topic]?, error: Error?) in
                    self?.trendsData.topics = topics
                    handler(error)
                }
            } else {
                handler(error)
            }
        }
    }
    
}
