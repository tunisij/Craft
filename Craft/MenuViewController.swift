//
//  MenuViewController.swift
//  CIS380
//
//  Created by John Tunisi on 11/30/15.
//  Copyright © 2015 John Tunisi. All rights reserved.
//

import UIKit
import Parse

class MenuViewController: UITableViewController {
    
    var menuArray = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadSchedule()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func pullToRefreshActivated(sender: UIRefreshControl) {
        loadSchedule()
        sender.endRefreshing();
    }
    
    func loadSchedule() {
        let query = PFQuery(className:"menu")
        query.whereKey("restaurantID", equalTo: (PFUser.currentUser()?.getRestaurantID())!)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    self.menuArray.removeAll()
                    for object in objects {
                        var instance = Dictionary<String, String>()
                        instance["Name"] = object["Name"] as? String
                        instance["Description"] = object["Description"] as? String
                        instance["URL"] = object["URL"] as? String
                        
                        self.menuArray.append(instance)
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
        return menuArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath)
        
        if let object = menuArray[indexPath.row] as? Dictionary<String, String> {
            if indexPath.row % 2 == 1 {
                cell.backgroundColor = UIColor(red: 255/255, green: 219/255, blue: 161/255, alpha: 1.0)
            } else {
                cell.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            }
            
            //                if let url = NSURL(string: object["URL"]!) {
            //                    if let data = NSData(contentsOfURL: url) {
            //                        cell.imageLabel.image = UIImage(data: data)
            //                    }
            //                }
            cell.textLabel!.text = object["Name"]
            cell.detailTextLabel?.text = object["Description"]
        }
        
        return cell
    }

}

