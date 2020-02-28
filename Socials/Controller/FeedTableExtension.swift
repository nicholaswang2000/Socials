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
    
    func setupFriendsList() {
        let db = Database.database().reference()
        let usersNode = db.child("Users")
        usersNode.observeSingleEvent(of: .value) { (snapshot) in
            guard let userDict = snapshot.value as? [String: [String: String]] else {
                print("friends error")
                return
            }
            
            // loop through the users dictionary
            for (userId, _) in userDict {
                guard let userInfoDict = userDict[userId] else {
                    print("friends error 2")
                    return
                }
                self.feedList.append(userInfoDict["name"]!)
            }
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath)
            as! FeedCell
        
        cell.nameLabel.text = feedList[index].eventName
        return cell
    }
    
    
}
