//
//  FeedViewController.swift
//  Socials
//
//  Created by Nicholas Wang on 2/28/20.
//  Copyright © 2020 Nicholas Wang. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var feedList: [Feed] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func newSocial(_ sender: Any) {
        self.performSegue(withIdentifier: "newSocial", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}
