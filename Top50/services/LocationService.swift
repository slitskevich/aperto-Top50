//
//  LocationService.swift
//  Top50
//
//  Created by slava litskevich on 02.04.18.
//  Copyright © 2018 slava litskevich. All rights reserved.
//

import Foundation
import CoreLocation

enum LocationError: Error {
    case locationRequestError
    case locationServiceDisabledError
    case noLocationError
}

extension LocationError : LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .locationServiceDisabledError:
            return NSLocalizedString("location.disabled", comment: "Location service disabled message")
        default:
            return NSLocalizedString("location.load.failure", comment: "Location load failure message")
        }
    }
}

class LocationService {
    func getCurrentLocation(handler: @escaping ((Location?, Error?) -> ())) {
        if let location = CLLocationManager().location {
            let baseURL = "https://api.flickr.com/services/rest/?&method=flickr.places.findByLatLon"
            let apiString = "&api_key=\(Configuration.shared.flickrApiKey)"
            let searchString = "&lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&format=json&nojsoncallback=?"
            
            let requestURL = URL(string: baseURL + apiString + searchString)!
            URLSession.shared.dataTask(with: requestURL, completionHandler: { data, response, error -> Void in
                if (error == nil) {
                    do {
                        let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                        if let places = (result!["places"] as? [String: AnyObject]),
                            let place = (places["place"] as? [[String: AnyObject]])?[0],
                            let id = place["woeid"] as? String,
                            let name = place["name"] as? String {
                            handler(Location(locationId: id, name: name), nil)
                        } else {
                            handler(nil, LocationError.noLocationError)
                        }
                    } catch let jsonError {
                        print(jsonError)
                        handler(nil, LocationError.locationRequestError)
                    }
                } else {
                    handler(nil, LocationError.locationRequestError)
                }
            }).resume()
        } else {
            handler(nil, LocationError.locationServiceDisabledError)
        }
    }
}
