//
//  TwitterService.swift
//  Top50
//
//  Created by slava litskevich on 02.04.18.
//  Copyright © 2018 slava litskevich. All rights reserved.
//

import Foundation
import TwitterKit

enum TrendsError: Error {
    case trendsRequestError
    case noTrendsError
}

extension TrendsError : LocalizedError {
    public var errorDescription: String? {
        switch self {
        default:
            return NSLocalizedString("trends.load.failure", comment: "Trends load failure message")
        }
    }
}

class TrendsService {
    let API_URL =  "https://api.twitter.com/1.1"
    let TRENDS_PATH = "trends/place.json"
    let HTTP_GET = "GET"
    let ID_PARAMETER = "id"

    func loadTrends(locationId: String, handler: @escaping (([Topic]?, Error?) -> ())) {
        let url = "\(API_URL)/\(TRENDS_PATH)"
        
        let client = TWTRAPIClient()
        let params = [ID_PARAMETER: locationId]
        var clientError : NSError?
        
        let request = client.urlRequest(withMethod: HTTP_GET, urlString: url, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, error) -> Void in
            if error == nil {
                do {
                    let result = try data?.parseTrendsResponseData()
                    if result != nil {
                        handler(result, nil)
                    } else {
                        handler(nil, TrendsError.noTrendsError)
                    }
                } catch {
                    handler(nil, TrendsError.trendsRequestError)
                }
            } else {
                handler(nil, TrendsError.trendsRequestError)
            }
        }
    }

}

extension Data {
    func parseTrendsResponseData() throws -> [Topic]? {
        let json = try JSONSerialization.jsonObject(with: self, options: [])
        if let trends = (json as? [AnyObject])?[0]["trends"] as? [[String: AnyObject]] {
            var result = [Topic]()
            for next in trends {
                result.append(Topic(attributes: next))
            }
            return result
        }
        return nil
    }
}

