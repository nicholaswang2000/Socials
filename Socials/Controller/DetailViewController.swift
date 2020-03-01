//
//  DetailViewController.swift
//  Socials
//
//  Created by Nicholas Wang on 2/28/20.
//  Copyright © 2020 Nicholas Wang. All rights reserved.
//

import UIKit
import Firebase

class DetailViewController: UIViewController {

    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var hostLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var interestedPeopleLabel: UILabel!
    
    var eventName: String!
    var hostName: String!
    var imageV: UIImage!
    var people: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func markInterested(_ sender: Any) {
        let auth = Auth.auth()
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
                if interestedPeople.contains((auth.currentUser?.email)!) {
                    self.displayAlert(title: "Error", message: "You're already interested dummy")
                } else {
                    interestedPeople.append((auth.currentUser?.email)!)
                    eventsNode.child(event).updateChildValues(["interestedList": interestedPeople])
                }
            }
        }
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
