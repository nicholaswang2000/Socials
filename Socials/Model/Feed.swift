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
    var image: UIImage
    var interestedNum: Int
    
    init(_ poster: String, _ name: String, _ img: UIImage) {
        posterName = poster
        eventName = name
        image = img
        interestedNum = 1
    }
    
    func addOneInterested() {
        interestedNum += 1
    }
}
