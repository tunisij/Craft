//
//  HomeViewController.swift
//  CIS380
//
//  Created by John Tunisi on 11/30/15.
//  Copyright © 2015 John Tunisi. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class HomeViewController: UITableViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate  {

    var homeArray = [AnyObject]()
    var indicator = UIActivityIndicatorView()

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if PFUser.currentUser() == nil {
            self.performSegueWithIdentifier("loginSegue", sender: self)
        } else {
            indicator.startAnimating()
            indicator.backgroundColor = UIColor.whiteColor()
            loadSchedule()
            indicator.stopAnimating()
            indicator.hidesWhenStopped = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func pullToRefreshActivated(sender: UIRefreshControl) {
        loadSchedule()
        sender.endRefreshing();
    }
    
    func loadSchedule() {
        let query = PFQuery(className:"news")
        query.addDescendingOrder("createdAt")
        query.whereKey("restaurantID", equalTo: PFUser.currentUser()!.getRestaurantID())
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    self.homeArray.removeAll()
                    for object in objects {
                        var instance = Dictionary<String, String>()
                        instance["Title"] = object["Title"] as? String
                        instance["Description"] = object["Description"] as? String
                        
                        self.homeArray.append(instance)
                        self.tableView.reloadData()
                    }
                }
            } else {
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeCell", forIndexPath: indexPath) as! HomeTableCell
        
        if let object = homeArray[indexPath.row] as? Dictionary<String, String> {
            if indexPath.row % 2 == 1 {
                cell.backgroundColor = UIColor(red: 255/255, green: 219/255, blue: 161/255, alpha: 1.0)
            } else {
                cell.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            }
            cell.title!.text = object["Title"]
            cell.story.text = object["Description"]
        }
        
        return cell
    }
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 40, 40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        
    }

}

