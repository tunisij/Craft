//
//  RegisterRestaurantViewController.swift
//  CIS380
//
//  Created by John Tunisi on 12/8/15.
//  Copyright © 2015 John Tunisi. All rights reserved.
//

import UIKit
import Parse

class RegisterRestaurantViewController: UIViewController, UITextFieldDelegate {
    
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
        
        emailTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        restaurantNameTextField.delegate = self
        restaurantIDTextField.delegate = self
        phoneNumberTextField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == emailTextField {
            if validateEmailAddress() {
                textField.resignFirstResponder()
                usernameTextField.becomeFirstResponder()
            }
        } else if textField == usernameTextField {
            if validateUsername() {
                textField.resignFirstResponder()
                passwordTextField.becomeFirstResponder()
            }
        } else if textField == passwordTextField {
            if validatePassword() {
                textField.resignFirstResponder()
                restaurantNameTextField.becomeFirstResponder()
            }
        } else if textField == restaurantNameTextField {
            if validateRestaurantName() {
                textField.resignFirstResponder()
                restaurantIDTextField.becomeFirstResponder()
            }
        } else if textField == restaurantIDTextField {
            if validateId() {
                textField.resignFirstResponder()
                phoneNumberTextField.becomeFirstResponder()
            }
        } else if textField == phoneNumberTextField {
            if validatePhoneNumber() {
                textField.resignFirstResponder()
            }
        }
        return true
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
    
    @IBAction func registerButtonClicked(sender: AnyObject) {
        if checked {
            if validateEmailAddress() && validateUsername() && validatePassword() && validateRestaurantName() && validateId() && validatePhoneNumber() {
                let newUser = PFUser()
                newUser.username = usernameTextField.text
                newUser.password = passwordTextField.text
                newUser.email = emailTextField.text
                
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
    
    func validateEmailAddress() -> Bool {
        if emailTextField.text!.characters.count < 8 {
            let alert = UIAlertController(title: "Invalid", message: "Please enter a valid email address", preferredStyle: UIAlertControllerStyle.Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(defaultAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func validateUsername() -> Bool {
        if usernameTextField.text!.characters.count < 5 {
            let alert = UIAlertController(title: "Invalid", message: "Username must be greater than 5 characters", preferredStyle: UIAlertControllerStyle.Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(defaultAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func validatePassword() -> Bool {
        if passwordTextField.text!.characters.count < 8 {
            let alert = UIAlertController(title: "Invalid", message: "Password must be greater than 8 characters", preferredStyle: UIAlertControllerStyle.Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(defaultAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func validateId() -> Bool {
        if restaurantIDTextField.text?.characters.count < 5 {
            let alert = UIAlertController(title: "Invalid", message: "Restaurant ID must be greater than 5 characters", preferredStyle: UIAlertControllerStyle.Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(defaultAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func validateRestaurantName() -> Bool {
        if restaurantNameTextField.text?.characters.count < 5 {
            let alert = UIAlertController(title: "Invalid", message: "Restaurant Name must be greater than 5 characters", preferredStyle: UIAlertControllerStyle.Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(defaultAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func validatePhoneNumber() -> Bool {
        if phoneNumberTextField.text?.characters.count < 10 {
            let alert = UIAlertController(title: "Invalid", message: "Invalid phone number", preferredStyle: UIAlertControllerStyle.Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(defaultAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
}