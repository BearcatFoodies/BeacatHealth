//
//  BreakfastTableViewController.swift
//  BearcatHealth
//
//  Created by Pachipulusu,Venkatakotianilkumar on 10/6/16.
//  Copyright © 2016 Gayam,Prathibha. All rights reserved.
//

import UIKit
import Parse
import Bolts
//This class describes about the Breakfast table view controller functionality. It populates the data into Breakfast table view
class BreakfastTableViewController: UITableViewController {
    // MARK: - properties
    // This is an outlet for tableview
    @IBOutlet var breakfastTableView: UITableView!
    // it stores the breakfast items
    static var breakfastItems:[String] = []
    // A property wi=hich allows us to access appdelegate data
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    // An object which holds the selected breakfast
    var selectedBreakfast : FoodData = FoodData()
    // An object for paraseoperations class
    let parseOperations = ParseOperations()
    // It holds the breakfast intake calories objects
    var  breakfastIntakeCalories:[CaloriesData] = []
    // this property holds food information
    var foodInfo:[FoodData] = []
    
    // tag Identifier for tableview cell image label
    let dishImage = 100
    // tag Identifier for tableview cell dish name label
    let dishName = 101
    // tag Identifier for tableview cell dish calories label
    let dishCalories = 102
    // MARK: - Default methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Breakfast"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(breakfastIsHere(_:)), name: "Breakfast Is Served", object: nil)
    }
    override func viewWillAppear(animated: Bool) {
        breakfastTableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK: - Notifcation handler methods
    // This method relaoads the data once breakfast calories are fetched
    func breakfastIsHere(notification:NSNotification){
        self.tableView.reloadData()
    }
    // MARK: - Table view data source
    
    //Returns number of sections in a table
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //Returns number of rows in a section
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if foodInfo.count == 0{
            return 0
        }else{
            return foodInfo.count
        }
    }
    // populates data into tableview cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Breakfast", forIndexPath: indexPath)
        let dishNameLBL:UILabel = cell.viewWithTag(dishName) as! UILabel
        let dishCaloriesLBL:UILabel = cell.viewWithTag(dishCalories) as! UILabel
        let dishIV:UIImageView = cell.viewWithTag(dishImage) as! UIImageView
        dishNameLBL.text = self.foodInfo[indexPath.row].itemName
        dishCaloriesLBL.text = String(self.foodInfo[indexPath.row].calories ) + " cal"
        dishIV.image = UIImage(named:"\(self.foodInfo[indexPath.row].itemName).jpg")
        return cell
    }
    //It sets data into selected breakfast if an item is selected
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedBreakfast = foodInfo[indexPath.row]
    }
    //It resets data if selected breakfast cell is deselected
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedBreakfast = FoodData()
    }
    
    // MARK: - Calorie addition
    // This method adds calories in to breakfast calories if user clicks add calories button
    @IBAction func addCalories(sender: UIBarButtonItem) {
        let selectedIntake = CaloriesData()
        selectedIntake.itemName = selectedBreakfast.itemName
        selectedIntake.calories = selectedBreakfast.calories
        selectedIntake.dayServed = selectedBreakfast.dayServed
        selectedIntake.location           = selectedBreakfast.location
        selectedIntake.mealType = selectedBreakfast.mealType
        selectedIntake.sid  = appDelegate.userName
        if selectedIntake.calories == 0 {
            displayAlertWithTitle("",message: "Please select atleast one item")
            return
        }
        if breakfastIntakeCalories.count > 0 {
            for item in breakfastIntakeCalories {
                BreakfastTableViewController.breakfastItems.append(item.itemName)
            }
            if BreakfastTableViewController.breakfastItems.contains(selectedIntake.itemName){
                let addAlert = UIAlertController(title: "", message: "\(selectedIntake.itemName) is already present.Do you wish to add it again.", preferredStyle: UIAlertControllerStyle.Alert)
                addAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
                    self.appDelegate.breakfastIntakeCalories += selectedIntake.calories
                    self.parseOperations.saveCalorieIntake(selectedIntake)
                    self.performSegueWithIdentifier("breakfastCalories", sender: self)
                }))
                addAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { action in
                    return
                }))
                if presentedViewController ==  nil{
                    self.presentViewController(addAlert, animated: true, completion: nil)
                }
            } else {
                breakfastIntakeCalories.append(selectedIntake)
                self.appDelegate.breakfastIntakeCalories += selectedIntake.calories
                self.parseOperations.saveCalorieIntake(selectedIntake)
                self.performSegueWithIdentifier("breakfastCalories", sender: self)
            }
        } else {
            breakfastIntakeCalories.append(selectedIntake)
            self.appDelegate.breakfastIntakeCalories += selectedIntake.calories
            self.parseOperations.saveCalorieIntake(selectedIntake)
            self.performSegueWithIdentifier("breakfastCalories", sender: self)
        }
    }
    // MARK: - Alerts
    func displayAlertWithTitle(title:String, message:String){
        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction:UIAlertAction =  UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
