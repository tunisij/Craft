//
//  SignupViewController.swift
//  CIS380
//
//  Created by John Tunisi on 12/8/15.
//  Copyright © 2015 John Tunisi. All rights reserved.
//

import Parse

class SignupViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var restaurantIDTextField: UITextField!
    
    var window: UIWindow?
    var username: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.text = username
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func infoAction(sender: UIButton) {
        let alert = UIAlertController(title: "Restaurant ID", message: "Restaurant ID is an identifier unique to every restaurant location. If you were not provided one, ask your manager. If your restaurant does not have one, click 'Register Restaurant'", preferredStyle: UIAlertControllerStyle.Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func signUpAction(sender: AnyObject) {
        let username = self.usernameTextField.text
        let password = self.passwordTextField.text
        let email = self.emailTextField.text
        let finalEmail = email!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let id = restaurantIDTextField.text
        
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
        } else {
            let newUser = PFUser()
            newUser.username = username
            newUser.password = password
            newUser.email = finalEmail
            
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
                    restaurantID = self.restaurantIDTextField.text!
                    newUser["restaurantID"] = restaurantID
                    newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
                        if ((error) != nil) {
                            let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: UIAlertControllerStyle.Alert)
                            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                            alert.addAction(defaultAction)
                            self.presentViewController(alert, animated: true, completion: nil)
                            
                        } else {
                            self.presentViewController(HomeViewController(), animated: true, completion: nil)
                        }
                    })

                }
            } catch {
            }
        }
    }
    
    @IBAction func backButtonClicked(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}