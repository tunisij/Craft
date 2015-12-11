//
//  LoginViewController.swift
//  CIS380
//
//  Created by John Tunisi on 12/8/15.
//  Copyright © 2015 John Tunisi. All rights reserved.
//


import UIKit
import Parse
import ParseUI
import ParseFacebookUtilsV4

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(animated: Bool) {
        if PFUser.currentUser() != nil {
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == usernameTextField {
            if validateUsername() {
                textField.resignFirstResponder()
                passwordTextField.becomeFirstResponder()
            }
        } else if textField == passwordTextField {
            if validatePassword() {
                textField.resignFirstResponder()
                loginButtonClicked(passwordTextField)
            }
        }
        return true
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func loginButtonClicked(sender: AnyObject) {
        if validateUsername() {
            if validatePassword() {
                PFUser.logInWithUsernameInBackground(usernameTextField.text!, password: passwordTextField.text!, block: { (user, error) -> Void in
                    if ((user) != nil) {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "Error", message: "Incorrect username or password", preferredStyle: UIAlertControllerStyle.Alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alert.addAction(defaultAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                })
            }
        }
    }

    @IBAction func facebookLoginClicked(sender: UITapGestureRecognizer) {
        let permissions = ["public_profile"]
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, block: {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                if user!.getRestaurantID() != "" {
                    self.dismissViewControllerAnimated(false, completion: nil)
                } else {
                    self.performSegueWithIdentifier("facebookLoginSegue", sender: self)
                }
            }
        })
    }
    
    func validateUsername() -> Bool {
        if self.usernameTextField.text!.characters.count < 5 {
            let alert = UIAlertController(title: "Invalid", message: "Username must be at least 5 characters", preferredStyle: UIAlertControllerStyle.Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(defaultAction)
            presentViewController(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func validatePassword() -> Bool {
        if passwordTextField.text!.characters.count < 8 {
            let alert = UIAlertController(title: "Invalid", message: "Password must be at least 8 characters", preferredStyle: UIAlertControllerStyle.Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(defaultAction)
            presentViewController(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "signupSegue" {
//            let controller = segue.destinationViewController as! SignupViewController
//            controller.username = self.usernameTextField.text
        }
    }
    
}