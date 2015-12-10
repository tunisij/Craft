//
//  SettingsViewController.swift
//  CIS380
//
//  Created by John Tunisi on 11/30/15.
//  Copyright © 2015 John Tunisi. All rights reserved.
//

import Parse

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var restaurantIDTextField: UITextField!
    @IBOutlet weak var callRestaurantButton: UIButton!
    
    var phoneNumber: String = ""
    
    override func viewDidLoad() {
        restaurantIDTextField.text = PFUser.currentUser()?.getRestaurantID()
        callRestaurantButton.hidden = true
        let query = PFQuery(className: "RestaurantIdentification")
        query.whereKey("restaurantID", equalTo: (PFUser.currentUser()?.getRestaurantID())!)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        self.phoneNumber = object["phoneNumber"] as! String
                        self.callRestaurantButton.hidden = false
                    }
                }
            } else {
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    @IBAction func logoutButton(sender: UIButton) {
        PFUser.logOut()
        self.performSegueWithIdentifier("logoutSegue", sender: self)
    }
    
    @IBAction func callRestaurantButtonClicked(sender: UIButton) {
        let url = NSURL(string: "telprompt://\(phoneNumber)")
        UIApplication.sharedApplication().openURL(url!)
    }
}
