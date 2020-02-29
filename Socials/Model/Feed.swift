//
//  Feed.swift
//  Socials
//
//  Created by Nicholas Wang on 2/28/20.
//  Copyright © 2020 Nicholas Wang. All rights reserved.
//

import Foundation
import UIKit

class Feed {
    var posterName: String
    var eventName: String
    var description: String
    var image: String
    var interestedList: [String]
    
    init(_ poster: String, _ name: String, _ desc: String, _ img: String) {
        posterName = poster
        eventName = name
        description = desc
        image = img
        interestedList = [poster]
    }
    
    func addOneInterested(_ user: String) {
        interestedList.append(user)
    }
    
    func toDict() -> [String: Any] {
        return ["Poster": posterName, "Event": eventName, "Desc": description, "Image": image, "interestedList": interestedList]
    }
}
