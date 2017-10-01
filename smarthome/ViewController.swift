//
//  ViewController.swift
//  smarthome
//
//  Created by Ant on 01/10/2017.
//  Copyright © 2017 Mobile Computing Lab. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
class ViewController: UIViewController {
    @IBOutlet var usernameField:UITextField!
    @IBOutlet var passwordField:UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        Database.database().reference().child("Home").child("users").child("FCM").setValue(token)
        usernameField.text = "b@gmail.com"
        passwordField.text = "bbbbbb"
    }
    
    @IBAction func login() {
        Auth.auth().signIn(withEmail: usernameField.text!, password: passwordField.text!) { (user, error) in
                if let error = error {
                    print(error)
                    return
                }
                self.performSegue(withIdentifier: "openDashboard", sender: nil)
            
        }
    }
    
    
}

