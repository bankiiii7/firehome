//
//  DashboardViewController.swift
//  smarthome
//
//  Created by Nui on 01/10/2017.
//  Copyright © 2017 Mobile Computing Lab. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class DashboardViewController: UIViewController {

    var temp: String = ""
    let user = Auth.auth().currentUser
    
    @IBOutlet weak var tempstatus: UILabel!
    @IBOutlet weak var tempvalue: UILabel!
    @IBOutlet weak var brightnessValue: UILabel!
    @IBOutlet weak var humidityValue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = user {
            let uid = user.uid
            print(uid)
            getHomeId(uid: uid)
        }
    }
    
    func getHomeId(uid: String) {
        Database.database().reference().child("Home").child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.getSensorsValue(homeid: dictionary["home"] as! String)
            }
        })
    }
    func getSensorsValue(homeid:String) {
        Database.database().reference().child("Home").child(homeid).child("sensors").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let self = self else { return }
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.tempvalue.text = "\(dictionary["temperature"] as! Int)"
                self.brightnessValue.text = "\(dictionary["brightness"] as! Int)"
                self.humidityValue.text = "\(dictionary["humidity"] as! Int)"
            }
        })
    }
    
}
