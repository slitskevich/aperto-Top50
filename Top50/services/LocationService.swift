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
    
    
    func getGeoLocation(handler: @escaping ((Location?, Error?) -> ())) {
        let REQUEST_FORMAT = "https://search.yahoo.com/sugg/gossip/gossip-gl-location/?appid=weather&output=sd1&p2=pt&command=%@"

        if !CLLocationManager.locationServicesEnabled() {
            handler(nil, LocationError.locationServiceDisabledError)
        } else {
            if let location = CLLocationManager().location {
                CLGeocoder().reverseGeocodeLocation(location) {(placemarks: [CLPlacemark]?, error: Error?) in
                    if let locationPlacemarks = placemarks, locationPlacemarks.count > 0, let locality = locationPlacemarks[0].locality {
                        URLSession.shared.dataTask(with: URL(string: String(format: REQUEST_FORMAT, locality))!, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> () in
                            if (error == nil) {
                                do {
                                    let location = try data?.parseLocationResponseData()
                                    if location != nil {
                                        handler(location, nil)
                                    } else {
                                        handler(nil, LocationError.noLocationError)
                                    }
                                } catch {
                                    handler(nil, LocationError.locationRequestError)
                                }
                            } else {
                                handler(nil, LocationError.locationRequestError)
                            }
                        }).resume()
                    } else {
                        handler(nil, LocationError.noLocationError)
                    }
                }
            }
        }
        
    }
}

extension Data {
    func parseLocationResponseData() throws -> Location? {
        let ID_KEY = "woeid"
        let NAME_KEY = "n"
        let QUERY_SEPARATORS = "=&"

        let result = try JSONSerialization.jsonObject(with: self, options: []) as? NSDictionary
        if let places = (result!["r"] as? [[String: AnyObject]]), places.count > 0, let d = places[0]["d"] as? String {
            let comps = d.components(separatedBy: CharacterSet.init(charactersIn: QUERY_SEPARATORS))
            var woeid: String? = nil
            var name: String? = nil
            for i in 0 ..< comps.count {
                if comps[i] == ID_KEY && i < comps.count - 1 {
                    woeid = comps[i + 1]
                } else if comps[i] == NAME_KEY && i < comps.count - 1 {
                    name = comps[i + 1]
                }
            }
            if let locationId = woeid {
                return Location(locationId: locationId, name: name)
            }
        }
        return nil
    }
}
