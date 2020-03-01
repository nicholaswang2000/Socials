//
//  FeedTableExtension.swift
//  Socials
//
//  Created by Nicholas Wang on 2/28/20.
//  Copyright © 2020 Nicholas Wang. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath)
            as! FeedCell
        
        cell.nameLabel.text = "Name: \(feedList[index].eventName)"
        cell.posterLabel.text = "Host: \(feedList[index].posterName)"
        
        let db = Database.database().reference()
        let eventsNode = db.child("events")
        eventsNode.observeSingleEvent(of: .value) { (snapshot) in
            guard let userDict = snapshot.value as? [String: [String: Any]] else {
                print("friends error")
                return
            }
            
            for (event, _) in userDict {
                guard let userInfoDict = userDict[event] else {
                    print("friends error 2")
                    return
                }
                var interestedPeople = userInfoDict["interestedList"] as! [String]
                
                cell.numInterested.text = "\(interestedPeople.count) people interested"
            }
            
        }
        
        let storageRef = Storage.storage().reference().child("myImage.png")
        storageRef.downloadURL(completion: { (url, err) in
                if let err = err {
                    print("Error downloading image file, \(err.localizedDescription)")
                    return
                }
                storageRef.getData(maxSize: 1024 * 1024 * 1024) { data, error in
                  if let error = error {
                    print(error)
                  } else {
                    let image = UIImage(data: data!)
                    cell.imageThisLmao.image = image
                  }
                }
            }
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showSocial", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
