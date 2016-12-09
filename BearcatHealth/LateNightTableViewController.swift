//
//  LateNightTableViewController.swift
//  BearcatHealth
//
//  Created by Pachipulusu,Venkatakotianilkumar on 10/7/16.
//  Copyright © 2016 Gayam,Prathibha. All rights reserved.
//
import UIKit
class LateNightTableViewController: UITableViewController {
    var foodInfo:[FoodData] = []
    let dishImage = 100
    let dishName = 101
    let dishCalories = 102
    var selectedLateNight = FoodData()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let parseOperations = ParseOperations()
    var lateNightIntakeCalories:[CaloriesData] = []
    static var lateNightItems:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Late night"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(lateNightIsHere(_:)), name: "LateNight Is Served", object: nil)
    }
    func lateNightIsHere(notification:NSNotification){
        self.tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //return the number of sections in a table
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //return the number of rows in a section
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if foodInfo.count == 0{
            return 0
        }else{
            return foodInfo.count
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LateNight", forIndexPath: indexPath)
        let dishNameLBL:UILabel = cell.viewWithTag(dishName) as! UILabel
        let dishCaloriesLBL:UILabel = cell.viewWithTag(dishCalories) as! UILabel
        let dishIV:UIImageView = cell.viewWithTag(dishImage) as! UIImageView
        dishNameLBL.text = self.foodInfo[indexPath.row].itemName
        dishCaloriesLBL.text = String(self.foodInfo[indexPath.row].calories)  + " cal"
        dishIV.image = UIImage(named:"\(self.foodInfo[indexPath.row].itemName).jpg")
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        selectedLateNight = foodInfo[indexPath.row]
    }
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
       
        selectedLateNight = FoodData()
    }
    @IBAction func addCalories(sender: UIBarButtonItem) {
        let selectedIntake = CaloriesData()
        selectedIntake.itemName = selectedLateNight.itemName
        selectedIntake.calories = selectedLateNight.calories
        selectedIntake.dayServed = selectedLateNight.dayServed
        selectedIntake.location  = selectedLateNight.location
        selectedIntake.mealType = selectedLateNight.mealType
        selectedIntake.sid  = appDelegate.userName
        if selectedIntake.calories == 0 {
            displayAlertWithTitle("",message: "Please select atleast one item")
            return
        }
        if lateNightIntakeCalories.count > 0 {
            for item in lateNightIntakeCalories {
                LateNightTableViewController.lateNightItems.append(item.itemName)
            }
            if LateNightTableViewController.lateNightItems.contains(selectedIntake.itemName){
                let addAlert = UIAlertController(title: "", message: "\(selectedIntake.itemName) is already present.Do you wish to add it again.", preferredStyle: UIAlertControllerStyle.Alert)
                addAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
                    self.appDelegate.lateNightIntakeCalories += selectedIntake.calories
                    self.parseOperations.saveCalorieIntake(selectedIntake)
                    self.performSegueWithIdentifier("lateNightCalories", sender: self)
                }))
                addAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { action in
                    return
                }))
                if presentedViewController ==  nil{
                    self.presentViewController(addAlert, animated: true, completion: nil)
                }
            } else {
                lateNightIntakeCalories.append(selectedIntake)
                self.appDelegate.lateNightIntakeCalories += selectedIntake.calories
                self.parseOperations.saveCalorieIntake(selectedIntake)
                self.performSegueWithIdentifier("lateNightCalories", sender: self)
            }
        } else {
            lateNightIntakeCalories.append(selectedIntake)
            self.appDelegate.lateNightIntakeCalories += selectedIntake.calories
            self.parseOperations.saveCalorieIntake(selectedIntake)
            self.performSegueWithIdentifier("lateNightCalories", sender: self)
        }
    }
    func displayAlertWithTitle(title:String, message:String){
        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction:UIAlertAction =  UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
