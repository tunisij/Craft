//
//  SignupViewController.swift
//  CIS380
//
//  Created by John Tunisi on 12/8/15.
//  Copyright © 2015 John Tunisi. All rights reserved.
//

import Parse

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var restaurantIDTextField: UITextField!
    
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        restaurantIDTextField.delegate = self
        
//        usernameTextField.text = username
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(animated: Bool) {
        if PFUser.currentUser() != nil {
            self.dismissViewControllerAnimated(false, completion: nil)
        }
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
                restaurantIDTextField.becomeFirstResponder()
            }
        } else if textField == restaurantIDTextField {
            if validateId() {
                textField.resignFirstResponder()
                signUpAction(restaurantIDTextField)
            }
        }
        return true
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
        if validateEmailAddress() && validateUsername() && validatePassword() && validateId() {
            let newUser = PFUser()
            newUser.username = usernameTextField.text
            newUser.password = passwordTextField.text
            newUser.email = emailTextField.text
            
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
                            self.dismissViewControllerAnimated(false, completion: nil)
                        }
                    })
                }
            } catch {
            }

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
    
    @IBAction func backButtonClicked(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}