//
//  FeedViewController.swift
//  Socials
//
//  Created by Nicholas Wang on 2/28/20.
//  Copyright © 2020 Nicholas Wang. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var fullName: String!
    var feedList: [Feed] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEventsList()
        setupNavigationBar()
        tableView.layer.backgroundColor = UIColor.clear.cgColor

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func setupEventsList() {
        let db = Database.database().reference()
        let usersNode = db.child("events")
        usersNode.observeSingleEvent(of: .value) { (snapshot) in
            guard let userDict = snapshot.value as? [String: [String: Any]] else {
                print("friends error")
                return
            }
            
            for (event, _) in userDict {
                guard let userInfoDict = userDict[event] else {
                    print("friends error 2")
                    return
                }
                self.feedList.append(Feed(userInfoDict["Poster"] as! String, userInfoDict["Event"] as! String, userInfoDict["Desc"] as! String, userInfoDict["Image"] as! String))
            }
            self.tableView.reloadData()
        }
    }
    
    @objc func eventsListPressed() {
        self.performSegue(withIdentifier: "newSocial", sender: self)
    }

    
    @objc func logOut() {
        let auth = Auth.auth()
        try? auth.signOut()
        navigationController?.popViewController(animated: true)
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Events"
        navigationItem.setHidesBackButton(true, animated:true);
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOut))
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Event", style: .plain, target: self, action: #selector(eventsListPressed))
        navigationItem.rightBarButtonItem?.tintColor = .black

    }
    
    func getPeopleString(_ people: [String]) -> String {
        var str = "People Interested: "
        for p in people {
            str += p + ", "
        }
        str = String(str.dropLast())
        str = String(str.dropLast())
        return str
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailViewController {
            let db = Database.database().reference()
            let usersNode = db.child("events")
            usersNode.observeSingleEvent(of: .value) { (snapshot) in
                guard let userDict = snapshot.value as? [String: [String: Any]] else {
                    print("friends error")
                    return
                }
                
                for (event, _) in userDict {
                    guard let userInfoDict = userDict[event] else {
                        print("friends error 2")
                        return
                    }
                    destination.eventNameLabel.text = "Event Name: " + (userInfoDict["Event"] as! String)
                    destination.hostLabel.text = "Host: " + (userInfoDict["Poster"] as! String)
                    destination.interestedPeopleLabel.text = self.getPeopleString(userInfoDict["interestedList"] as! [String])
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
                        destination.image.image = image
                    }
                }
            })
        }
    }
}
