//
//  RegisterRestaurantViewController.swift
//  CIS380
//
//  Created by John Tunisi on 12/8/15.
//  Copyright © 2015 John Tunisi. All rights reserved.
//

import UIKit
import Parse

class RegisterRestaurantViewController: UIViewController {
    
    @IBOutlet weak var checkBox: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var restaurantNameTextField: UITextField!
    @IBOutlet weak var restaurantIDTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    var checked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func checkBoxClicked(sender: UITapGestureRecognizer) {
        if checked {
            checkBox.image = UIImage(named: "Unchecked Checkbox-100")
            checked = false
        } else {
            checkBox.image = UIImage(named: "Checked Checkbox 2-100")
            checked = true
        }
    }
    
    @IBAction func backButtonClicked(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func registerButtonClicked(sender: UIButton) {
        if checked {
            let username = self.usernameTextField.text
            let password = self.passwordTextField.text
            let email = self.emailTextField.text
            let phoneNumber = self.phoneNumberTextField.text
            let finalEmail = email!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            let id = restaurantIDTextField.text
            
            // Validate the text fields
            if username!.characters.count < 5 {
                let alert = UIAlertController(title: "Invalid", message: "Username must be greater than 5 characters", preferredStyle: UIAlertControllerStyle.Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(defaultAction)
                self.presentViewController(alert, animated: true, completion: nil)
                
            } else if password!.characters.count < 8 {
                let alert = UIAlertController(title: "Invalid", message: "Password must be greater than 8 characters", preferredStyle: UIAlertControllerStyle.Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(defaultAction)
                self.presentViewController(alert, animated: true, completion: nil)
                
            } else if email!.characters.count < 8 {
                let alert = UIAlertController(title: "Invalid", message: "Please enter a valid email address", preferredStyle: UIAlertControllerStyle.Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(defaultAction)
                self.presentViewController(alert, animated: true, completion: nil)
            } else if id?.characters.count < 5 {
                let alert = UIAlertController(title: "Invalid", message: "Restaurant ID must be greater than 5 characters", preferredStyle: UIAlertControllerStyle.Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(defaultAction)
                self.presentViewController(alert, animated: true, completion: nil)
            } else if phoneNumber?.characters.count < 10 {
                let alert = UIAlertController(title: "Invalid", message: "Invalid phone number", preferredStyle: UIAlertControllerStyle.Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(defaultAction)
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                let newUser = PFUser()
                newUser.username = username
                newUser.password = password
                newUser.email = finalEmail
                
                let query = PFQuery(className: "RestaurantIdentification")
                query.whereKey("restaurantID", equalTo: self.restaurantIDTextField.text!)
                
                do {
                    let result = try query.findObjects()
                    if result.count > 0 {
                        let alert = UIAlertController(title: "Invalid", message: "Restaurant ID is already in use. Try a different one.", preferredStyle: UIAlertControllerStyle.Alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alert.addAction(defaultAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    } else {
                        let restaurant = PFObject(className:"RestaurantIdentification")
                        restaurant["restaurantID"] = self.restaurantIDTextField.text
                        restaurant["RestaurantName"] = self.restaurantNameTextField.text
                        restaurant["phoneNumber"] = self.phoneNumberTextField.text
                        restaurant.saveInBackgroundWithBlock {
                            (success: Bool, error: NSError?) -> Void in
                            if (success) {
                                restaurantID = self.restaurantIDTextField.text!
                                newUser["restaurantID"] = restaurantID
                                newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
                                    if ((error) != nil) {
                                        let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: UIAlertControllerStyle.Alert)
                                        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                                        alert.addAction(defaultAction)
                                        self.presentViewController(alert, animated: true, completion: nil)
                                    } else {
                                        self.dismissViewControllerAnimated(false, completion: nil)
                                    }
                                })
                            } else {
                                let alert = UIAlertController(title: "Error", message: "Error saving. Please try again.", preferredStyle: UIAlertControllerStyle.Alert)
                                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                                alert.addAction(defaultAction)
                                self.presentViewController(alert, animated: true, completion: nil)
                            }
                        }
                    }
                } catch {
                    print("error")
                }
            }
        } else {
            let checkBoxAlert = UIAlertController(title: "Acknowledgement", message: "Please read the acknowledgement and agree to continue", preferredStyle: .Alert)
            checkBoxAlert.addAction(UIAlertAction(title:"Ok", style: .Default, handler: nil))
            self.presentViewController(checkBoxAlert, animated: true, completion: nil)
        }
    }
}