//
//  ManuallViewController.swift
//  smarthome
//
//  Created by Nui on 01/10/2017.
//  Copyright © 2017 Mobile Computing Lab. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
class ManuallViewController: UIViewController {
    
    @IBOutlet var autoswitch : UISwitch!
    @IBOutlet var lampswitch : UISwitch!
    @IBOutlet var fanswitch : UISwitch!
    let user = Auth.auth().currentUser
    var homeid = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        autoswitch.isOn = true
        lampswitch.isEnabled = false
        fanswitch.isEnabled = false
        
        if let user = user {
            let uid = user.uid
            print(uid)
            getHomeId(uid: uid)
        }
        
        
    }
    
    func getHomeId(uid: String) {
        Database.database().reference().child("Home").child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.homeid = dictionary["home"] as! String
                self.fanStatus(homeid: dictionary["home"] as! String)
                self.lampStatus(homeid: dictionary["home"] as! String)
                
            }
        })
    }
    
    func fanStatus(homeid:String){
        Database.database().reference().child("Home").child(homeid).child("devices").child("fan").observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            if let dictionary = snapshot.value as? [String: AnyObject] {
                if dictionary["status"] as? Int == 1 {
                    self.fanswitch.isOn = true
                } else {
                    self.fanswitch.isOn = false
                }
            }
        })
    }
    
    func lampStatus(homeid:String) {
        Database.database().reference().child("Home").child(homeid).child("devices").child("lamp").observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            if let dictionary = snapshot.value as? [String: AnyObject] {
                if dictionary["status"] as? Int == 1 {
                    self.lampswitch.isOn = true
                } else {
                    self.lampswitch.isOn = false
                }
            }
        })
    }
    
    @IBAction func autoSwiftPressed() {
        if autoswitch.isOn == true {
            Database.database().reference().child("Home").child(homeid).child("manual").setValue(0)
            lampswitch.isEnabled = false
            fanswitch.isEnabled = false
            
        } else {
            Database.database().reference().child("Home").child(homeid).child("manual").setValue(1)
            lampswitch.isEnabled = true
            fanswitch.isEnabled = true
        }
        
    }
    
    @IBAction func lampswitchPressed() {
        if lampswitch.isOn == true {
            Database.database().reference().child("Home").child(homeid).child("devices").child("lamp").child("status").setValue(1)
        } else {
            Database.database().reference().child("Home").child(homeid).child("devices").child("lamp").child("status").setValue(0)
        }
        
    }
    
    @IBAction func fanswitchPressed() {
        if fanswitch.isOn == true {
            Database.database().reference().child("Home").child(homeid).child("devices").child("fan").child("status").setValue(1)
        } else {
            Database.database().reference().child("Home").child(homeid).child("devices").child("fan").child("status").setValue(0)
        }
        
    }

}
