//
//  ScheduleViewController.swift
//  CIS380
//
//  Created by John Tunisi on 11/30/15.
//  Copyright © 2015 John Tunisi. All rights reserved.
//

import UIKit
import Parse

@objc class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var scheduleArray = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadSchedule(NSDate())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refreshTable(sender: UIRefreshControl) {
        loadSchedule(NSDate())
        sender.endRefreshing()
    }
    
    
    func loadSchedule(date: NSDate) {
        let query = PFQuery(className:"employee")
        query.whereKey("restaurantID", equalTo: (PFUser.currentUser()?.getRestaurantID())!)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    self.scheduleArray.removeAll()
                    for object in objects {
                        var instance = Dictionary<String, String>()
                        instance["URL"] = object["URL"] as? String
                        instance["AM"] = object["AM"] as? String
                        instance["PM"] = object["PM"] as? String
                        instance["NAME"] = object["NAME"] as? String
                        let parseDate = object["Date"] as! NSDate
                        
                        let calendar = NSCalendar.currentCalendar()
                        let dateComponents = calendar.components([.Year, .Month, .Day], fromDate: date)
                        let parseDateComponents = calendar.components([.Year, .Month, .Day], fromDate: parseDate)
                        
                        if dateComponents == parseDateComponents {
                            self.scheduleArray.append(instance)
                        }
                    }
                    self.tableView.reloadData()
                }
            } else {
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScheduleCell", forIndexPath: indexPath) as! ScheduleTableCell
        
            if let object = scheduleArray[indexPath.row] as? Dictionary<String, String> {
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
                cell.name!.text = object["NAME"]
                cell.timeAM!.text = object["AM"]
                cell.timePM!.text = object["PM"]
            }
        
        return cell
    }
    
    @IBAction func viewCalendar(sender: UIButton) {
        let url = NSURL(string: "calshow://")
        UIApplication.sharedApplication().openURL(url!)
    }
    
    
}