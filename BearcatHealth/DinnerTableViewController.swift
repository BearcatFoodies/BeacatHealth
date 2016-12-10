//
//  DinnerTableViewController.swift
//  BearcatHealth
//
//  Created by Gayam,Prathibha on 10/7/16.
//  Copyright © 2016 Gayam,Prathibha. All rights reserved.
//
import UIKit
class DinnerTableViewController: UITableViewController {
    // MARK: - properties
    // A class variable which keeps the track of dinner items
    static var dinnerItems:[String] = []
    // An object for paraseoperations class
    let parseOperations = ParseOperations()
    // A property which allows us to access Appdelegate data
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    // It holds dinner data
    var foodInfo:[FoodData] = []
    // Tag variable for image label in the table view cell
    let dishImage = 100
    //Tag variable for dish name label in the table view cell
    let dishName = 101
    //Tag variable for calories label in the table view cell
    let dishCalories = 102
    //It holds selected dinner information
    var selectedDinner = FoodData()
    // It holds dinner intake calories
    var dinnerIntakeCalories:[CaloriesData] = []
    // MARK: - Default methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Dinner"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(dinnerIsHere(_:)), name: "Dinner Is Served", object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Notification handler
    // It reloads table view once dinner data retrieved notification is received
    func dinnerIsHere(notification:NSNotification){
        self.tableView.reloadData()
    }
    // MARK: - Table view data source
    //return the number of sections in a table
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    // return the number of rows in a section
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if foodInfo.count == 0{
            return 0
        }else{
            return foodInfo.count
        }
    }
    // Loads the data into table view cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Dinner", forIndexPath: indexPath)
        let dishNameLBL:UILabel = cell.viewWithTag(dishName) as! UILabel
        let dishCaloriesLBL:UILabel = cell.viewWithTag(dishCalories) as! UILabel
        let dishIV:UIImageView = cell.viewWithTag(dishImage) as! UIImageView
        dishNameLBL.text = self.foodInfo[indexPath.row].itemName
        dishCaloriesLBL.text = String(self.foodInfo[indexPath.row].calories)  + " cal"
        dishIV.image = UIImage(named:"\(self.foodInfo[indexPath.row].itemName).jpg")
        return cell
    }
    //It sets data into selected dinner if an item is selected
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedDinner = foodInfo[indexPath.row]
    }
    //It resets data if selected dinner cell is deselected
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        selectedDinner = FoodData()
    }
    // MARK: - Calorie addition
    // This method adds calories in to dinner calories if user clicks add calories button
    @IBAction func addCalories(sender: UIBarButtonItem) {
        let selectedIntake = CaloriesData()
        selectedIntake.itemName = selectedDinner.itemName
        selectedIntake.calories = selectedDinner.calories
        selectedIntake.dayServed = selectedDinner.dayServed
        selectedIntake.location  = selectedDinner.location
        selectedIntake.mealType = selectedDinner.mealType
        selectedIntake.sid  = appDelegate.userName
        if selectedIntake.calories == 0 {
            displayAlertWithTitle("",message: "Please select atleast one item")
            return
        }
        if dinnerIntakeCalories.count > 0 {
            for item in dinnerIntakeCalories {
                DinnerTableViewController.dinnerItems.append(item.itemName)
            }
            if DinnerTableViewController.dinnerItems.contains(selectedIntake.itemName){
                let addAlert = UIAlertController(title: "", message: "\(selectedIntake.itemName) is already present.Do you wish to add it again.", preferredStyle: UIAlertControllerStyle.Alert)
                addAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
                    self.appDelegate.dinnerIntakeCalories += selectedIntake.calories
                    self.parseOperations.saveCalorieIntake(selectedIntake)
                    self.performSegueWithIdentifier("dinnerCalories", sender: self)
                }))
                addAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { action in
                    return
                }))
                if presentedViewController ==  nil{
                    self.presentViewController(addAlert, animated: true, completion: nil)
                }
            } else {
                dinnerIntakeCalories.append(selectedIntake)
                self.appDelegate.dinnerIntakeCalories += selectedIntake.calories
                self.parseOperations.saveCalorieIntake(selectedIntake)
                self.performSegueWithIdentifier("dinnerCalories", sender: self)
            }
        } else {
            dinnerIntakeCalories.append(selectedIntake)
            self.appDelegate.dinnerIntakeCalories += selectedIntake.calories
            self.parseOperations.saveCalorieIntake(selectedIntake)
            self.performSegueWithIdentifier("dinnerCalories", sender: self)
        }
    }
    // MARK: - Alert
    func displayAlertWithTitle(title:String, message:String){
        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction:UIAlertAction =  UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
