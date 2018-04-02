//
//  LocationService.swift
//  Top50
//
//  Created by slava litskevich on 02.04.18.
//  Copyright © 2018 slava litskevich. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService {
//    http://query.yahooapis.com/v1/public/yql?q=select+place+from+flickr.places+where+lat=%f+and+lon=%f&format=json
    
    let locationManager = CLLocationManager()
    let flickrApiKey = "9ef7317e60e77f523f46a28e78f1810d"
    
    func getCurrentLocation(handler: @escaping ((String?, Error?) -> ())) {
        if let location = locationManager.location {
            let baseURL = "https://api.flickr.com/services/rest/?&method=flickr.places.findByLatLon"
            let apiString = "&api_key=\(flickrApiKey)"
            let searchString = "&lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&format=json&nojsoncallback=?"
            
            let requestURL = URL(string: baseURL + apiString + searchString)!
            URLSession.shared.dataTask(with: requestURL, completionHandler: { data, response, error -> Void in
                do {
                    var backToString = String(data: data!, encoding: String.Encoding.utf8) as String!
                    print(backToString)
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    if let places = (result!["places"] as? [String: AnyObject]),
                       let place0 = (places["place"] as? [[String: AnyObject]])?[0],
                        let id = place0["woeid"] as? String {
                        print(id)
                        handler(id, nil)
                    }
//                    if let woeid = (result["places"]? as [String: AnyObject])
                    handler(nil, nil)
                } catch {
                    print(error)
                    handler(nil, error)
                }
            }).resume()
        }
        handler(nil, nil)
    }
    
    func GetFlickrData(tags: String) {
        
    }

}
