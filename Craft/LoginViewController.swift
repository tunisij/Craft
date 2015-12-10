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

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(animated: Bool) {
        if PFUser.currentUser() != nil {
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func loginButtonClicked(sender: UIButton) {
        let username = self.usernameTextField.text
        let password = self.passwordTextField.text
        
        if username!.characters.count < 5 {
            let alert = UIAlertController(title: "Invalid", message: "Username must be at least 5 characters", preferredStyle: UIAlertControllerStyle.Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(defaultAction)
            presentViewController(alert, animated: true, completion: nil)
            
        } else if password!.characters.count < 8 {
            let alert = UIAlertController(title: "Invalid", message: "Password must be at least 8 characters", preferredStyle: UIAlertControllerStyle.Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(defaultAction)
            presentViewController(alert, animated: true, completion: nil)
            
        } else {
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            
            PFUser.logInWithUsernameInBackground(username!, password: password!, block: { (user, error) -> Void in
                spinner.stopAnimating()
                
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
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "signupSegue" {
            let controller = segue.destinationViewController as! SignupViewController
            controller.username = self.usernameTextField.text
        }
    }
    
}