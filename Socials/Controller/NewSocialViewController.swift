//
//  NewSocialViewController.swift
//  Socials
//
//  Created by Nicholas Wang on 2/28/20.
//  Copyright © 2020 Nicholas Wang. All rights reserved.
//

import UIKit
import Firebase

class NewSocialViewController: UIViewController {
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventNameField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addImage(_ sender: Any) {
        showImagePickerController()
    }
    
    @IBAction func addEvent(_ sender: Any) {
        
        let storageRef = Storage.storage().reference().child("myImage.png")
        
        let auth = Auth.auth()
        
        if let image = eventImage.image {
            
            let uploadData = UIImage.pngData(image)()!
            
            storageRef.putData(uploadData, metadata: nil, completion:
                {(metadata, error) in
                    if error != nil {
                        print(error)
                        return
                    }
                    print(metadata)
                    
                    let newFeed = Feed((auth.currentUser?.email)!, self.eventNameField.text ?? "No name", self.descriptionField.text ?? "No description", storageRef.fullPath)
                    
                    let ref = Database.database().reference(withPath: "events")
                    let id = ref.childByAutoId().key
                    ref.child(id!).setValue(newFeed.toDict())
            })
            
            
            
            self.navigationController?.popViewController(animated: true)
        } else {
            self.displayAlert(title: "Whoops", message: "Your event sucks lmao")
        }
    }

    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension NewSocialViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            eventImage.image = image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            eventImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
}
