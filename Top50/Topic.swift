//
//  Topic.swift
//  Top50
//
//  Created by slava litskevich on 02.04.18.
//  Copyright © 2018 slava litskevich. All rights reserved.
//

import Foundation

class Topic {
    
    let NAME = "name"
    
    let name: String?
    
    init(attributes: [String: AnyObject]) {
        self.name = attributes[NAME] as? String
    }
}
