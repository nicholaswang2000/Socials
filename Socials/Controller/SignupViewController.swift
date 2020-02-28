//
//  SignupViewController.swift
//  Socials
//
//  Created by Nicholas Wang on 2/28/20.
//  Copyright © 2020 Nicholas Wang. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController {

    @IBOutlet weak var fullnameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func handleRegister() {
        let fullname = fullnameField.text!
        let username = usernameField.text!
        let password = passwordField.text!
        let email = emailField.text!
        
        if password.count < 6 {
            self.displayAlert(title: "Error", message: "Password must be 6 characters or longer")
        }
        
        let auth = Auth.auth()      // authentication object
        
        // 1. Create User
        auth.createUser(withEmail: email, password: password) { (user, error) in
            guard error == nil else {
                self.displayAlert(title: "Error", message: "Check if textfields are valid")
                print(error.debugDescription)
                return
            }
            guard user != nil else {
                self.displayAlert(title: "Error", message: "User Error")
                return
            }
            
            // 2. Enter new node into database
            let db = Database.database().reference()        // gets database reference
            let usersNode = db.child("Users")               // get into the Users folder
            guard let newUserId = usersNode.childByAutoId().key else {       // references the new node
                print("Hello")
                return
            }
            let userNode = usersNode.child(newUserId)
            userNode.updateChildValues(["username": username, "name": fullname])
            
            // 3. Segue to Login
            self.performSegue(withIdentifier: "signupToFeed", sender: self)
        }
        
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signupBtn(_ sender: Any) {
        handleRegister()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
