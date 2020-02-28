//
//  LoginViewController.swift
//  Socials
//
//  Created by Nicholas Wang on 2/28/20.
//  Copyright © 2020 Nicholas Wang. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func handleLogin() {
        let email = usernameField.text!
        let password = passwordField.text!
        
        let auth = Auth.auth()
        auth.signIn(withEmail: email, password: password, completion: { (user, error) in
            guard error == nil else {
                self.displayAlert(title: "Error", message: "Username or Password Incorrrect")
                print(error.debugDescription)
                return
            }
            guard user != nil else {
                self.displayAlert(title: "Error", message: "User Error")
                return
            }
            self.performSegue(withIdentifier: "loginToFeed", sender: self)
        })
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        handleLogin()
    }

}
