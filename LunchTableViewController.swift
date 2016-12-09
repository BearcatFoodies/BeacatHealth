//
//  LunchTableViewController.swift
//  BearcatHealth
//
//  Created by Pachipulusu,Venkatakotianilkumar on 10/7/16.
//  Copyright © 2016 Gayam,Prathibha. All rights reserved.
//
import UIKit
//This class describes about the Lunch table view controller functionality. It populates the data into lunch table view
class LunchTableViewController: UITableViewController {
    let parseOperations = ParseOperations()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var foodInfo:[FoodData] = []
    var selectedLunch : FoodData = FoodData()
    var  lunchIntakeCalories:[CaloriesData] = []
    static var lunchItems:[String] = []
    let dishImage = 100
    let dishName = 101
    let dishCalories = 102
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Lunch"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(lunchIsHere(_:)), name: "Lunch Is Served", object: nil)
    }
    func lunchIsHere(notification:NSNotification){
        self.tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Returns number of section in a table
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //returns number of rows in a table
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if foodInfo.count == 0{
            return 0
        }else{
            return foodInfo.count
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Lunch", forIndexPath: indexPath)
        let dishNameLBL:UILabel = cell.viewWithTag(dishName) as! UILabel
        let dishCaloriesLBL:UILabel = cell.viewWithTag(dishCalories) as! UILabel
        let dishIV:UIImageView = cell.viewWithTag(dishImage) as! UIImageView
        dishNameLBL.text = self.foodInfo[indexPath.row].itemName
        dishCaloriesLBL.text = String(self.foodInfo[indexPath.row].calories) +  " cal"
        dishIV.image = UIImage(named:"\(self.foodInfo[indexPath.row].itemName).jpg")
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
               selectedLunch = foodInfo[indexPath.row]
    }
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
      
        selectedLunch = FoodData()
    }
    @IBAction func addCalories(sender: UIBarButtonItem) {
        let selectedIntake = CaloriesData()
        selectedIntake.itemName = selectedLunch.itemName
        selectedIntake.calories = selectedLunch.calories
        selectedIntake.dayServed = selectedLunch.dayServed
        selectedIntake.location  = selectedLunch.location
        selectedIntake.mealType = selectedLunch.mealType
        selectedIntake.sid  = appDelegate.userName
        
        if selectedIntake.calories == 0 {
            displayAlertWithTitle("",message: "Please select atleast one item")
            return
        }
        if lunchIntakeCalories.count > 0 {
            for item in lunchIntakeCalories {
                LunchTableViewController.lunchItems.append(item.itemName)
            }
            if LunchTableViewController.lunchItems.contains(selectedIntake.itemName){
                let addAlert = UIAlertController(title: "", message: "\(selectedIntake.itemName) is already present.Do you wish to add it again.", preferredStyle: UIAlertControllerStyle.Alert)
                addAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
                    self.appDelegate.lunchIntakeCalories += selectedIntake.calories
                    self.parseOperations.saveCalorieIntake(selectedIntake)
                    self.performSegueWithIdentifier("lunchCalories", sender: self)
                }))
                addAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { action in
                    return
                }))
                if presentedViewController ==  nil{
                    self.presentViewController(addAlert, animated: true, completion: nil)
                }
            } else {
                lunchIntakeCalories.append(selectedIntake)
                self.appDelegate.lunchIntakeCalories += selectedIntake.calories
                self.parseOperations.saveCalorieIntake(selectedIntake)
                self.performSegueWithIdentifier("lunchCalories", sender: self)
            }
        } else {
            lunchIntakeCalories.append(selectedIntake)
            self.appDelegate.lunchIntakeCalories += selectedIntake.calories
            self.parseOperations.saveCalorieIntake(selectedIntake)
            self.performSegueWithIdentifier("lunchCalories", sender: self)
        }
    }
    func displayAlertWithTitle(title:String, message:String){
        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction:UIAlertAction =  UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
