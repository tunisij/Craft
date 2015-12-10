//
//  EnterRestaurantIDViewController.swift
//  CIS380
//
//  Created by John Tunisi on 12/9/15.
//  Copyright © 2015 John Tunisi. All rights reserved.
//

import UIKit
import Parse

class EnterRestaurantIDViewController: UIViewController {
    
    @IBOutlet weak var restaurantIDTextField: UITextField!
    
    @IBAction func continueButtonClicked(sender: UIButton) {
        let query = PFQuery(className: "RestaurantIdentification")
        let id = self.restaurantIDTextField.text
        query.whereKey("restaurantID", equalTo: id!)
        
        do {
            let result = try query.findObjects()
            if result.count != 1 {
                let alert = UIAlertController(title: "Invalid", message: "Restaurant ID not found. Please verify ID with manager.", preferredStyle: UIAlertControllerStyle.Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(defaultAction)
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                PFUser.currentUser()!.setRestaurantID(self.restaurantIDTextField.text!)
                self.dismissViewControllerAnimated(false, completion: nil)
            }
        } catch {
        }
    }
    
    @IBAction func startOverButtonClicked(sender: UIButton) {
        PFUser.logOut()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}