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
    // MARK: - properties
    // An object for paraseoperations class
    let parseOperations = ParseOperations()
    // A property wi=hich allows us to access Appdelegate data
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    // this property holds food information
    var foodInfo:[FoodData] = []
    // this property holds selected lunch information so that it can be added to intake calories
    var selectedLunch : FoodData = FoodData()
    // It holds the lunch intake calories objects
    var lunchIntakeCalories:[CaloriesData] = []
    // It holds the lunch items selected
    static var lunchItems:[String] = []
    // tag Identifier for tableview cell image label
    let dishImage = 100
    // tag Identifier for tableview cell dishname label
    let dishName = 101
    // tag Identifier for tableview cell dish calories label
    let dishCalories = 102
    // MARK: - Default methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Lunch"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(lunchIsHere(_:)), name: "Lunch Is Served", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Notification handler
    // It reloads table view once lunch data retrieved notification is received
    func lunchIsHere(notification:NSNotification){
        self.tableView.reloadData()
    }
    // MARK: - Table view data source
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
    // Populates data into table view cells
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
    //It sets data into selected lunch if an item is selected
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedLunch = foodInfo[indexPath.row]
    }
    //It resets data if selected lunch cell is deselected
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedLunch = FoodData()
    }
    // MARK: - Calorie addition
    // This method adds calories in to lunch calories if user clicks add calories button
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
    // MARK: - Alert
    func displayAlertWithTitle(title:String, message:String){
        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction:UIAlertAction =  UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
