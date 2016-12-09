//
//  FirstViewController.swift
//  BearcatHealth
//
//  Created by Gayam,Prathibha on 10/6/16.
//  Copyright © 2016 Gayam,Prathibha. All rights reserved.
// This view controller provides the various menu options available
import UIKit
import Parse
class MenuViewController: UIViewController {
    // This property allows us to share app delgate class data
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
   // Created implicitly unwrapped optional for parase opeartions class
    var parseOperations:ParseOperations!
    // Holds breakfast data
    var  breakfastData:[FoodData] = []
    // Holds lunch data
    var lunchData:[FoodData] = []
    // Holds dinner data
    var dinnerData:[FoodData] = []
    // Holds latenight data
    var lateNightData:[FoodData] = []
    // created an object profile class
    var user = Profile()
   // This static property holds the number of users retrived from the database
    static var userscount  = 0
   // Static property holds the breakfast intake calories
    static var  breakfastIntakeCalories:[CaloriesData] = []
    // Static property holds the lunch intake calories
    static var lunchIntakeCalories:[CaloriesData] = []
    // Static property holds the dinner intake calories
    static var dinnerIntakeCalories:[CaloriesData] = []
    // Static property holds latenight intake calories
    static var lateNightIntakeCalories:[CaloriesData] = []
   
    // We will be displaying user intake calories . So We are retriving intake calories inadvance to handle the delay due to parse operations
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "hotel-dining.jpg")!)
        displayAlertWithTitle("", message: "Logged in successfully!! Want to go through the menu ? Click on the menu types")
        self.title = "Menu"
        parseOperations = ParseOperations()
        parseOperations.retriveBreakfastCalorieIntake(appDelegate.userName)
        parseOperations.retriveLunchCalorieIntake(appDelegate.userName)
        parseOperations.retriveDinnerCalorieIntake(appDelegate.userName)
        parseOperations.retriveLateNightCalorieIntake(appDelegate.userName)
        parseOperations.retrieveUser(appDelegate.userName)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(userDetails(_:)), name: "User retrived", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(breakfastCaloriesHere(_:)), name: "User breakfast calories retrived", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(lunchCaloriesHere(_:)), name: "User lunch calories retrived", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(dinnerCaloriesHere(_:)), name: "User dinner calories retrived", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(lateNightCaloriesHere(_:)), name: "User latenight calories retrived", object: nil)
    }
  
    // This method stores the user details. And calls calorie intake method
    func userDetails(notification:NSNotification){
        for user in parseOperations.user {
            self.user = user
            appDelegate.user = self.user
        }
        MenuViewController.userscount = parseOperations.user.count
        if parseOperations.user.count > 0 {
            calorieIntake()
        }
    }
    // This notification method adds the breakfast intake calories once data is fetched from parse database.
    func breakfastCaloriesHere(notification:NSNotification){
        MenuViewController.breakfastIntakeCalories = parseOperations.breakfastIntake
        for calori in MenuViewController.breakfastIntakeCalories {
            appDelegate.breakfastIntakeCalories += calori.calories
        }
    }
     // This notification method adds the lunch intake calories once data is fetched from parse database.
    func lunchCaloriesHere(notification:NSNotification){
        MenuViewController.lunchIntakeCalories = parseOperations.lunchIntake
        for calori in MenuViewController.lunchIntakeCalories {
            appDelegate.lunchIntakeCalories += calori.calories
        }
    }
     // This notification method adds the dinner intake calories once data is fetched from parse database.
    func dinnerCaloriesHere(notification:NSNotification){
        MenuViewController.dinnerIntakeCalories = parseOperations.dinnerIntake
        for calori in MenuViewController.dinnerIntakeCalories {
            appDelegate.dinnerIntakeCalories += calori.calories
        }
    }
     // This notification method adds the latenight intake calories once data is fetched from parse database.
    func lateNightCaloriesHere(notification:NSNotification){
        MenuViewController.lateNightIntakeCalories = parseOperations.lateNightIntake
        for calori in MenuViewController.lateNightIntakeCalories {
            appDelegate.lateNightIntakeCalories += calori.calories
        }
    }
    // Below method calculates calories supposed to be consumed based on the user profile(BMI)
    func calorieIntake () {
        var calories = 0.0
        let weight: Double = Double(user.weight)!
        let height: Double = Double(user.height)!
        let age: Double = Double(user.age)
        if user.gender == "Male" {
            if user.activity == "Light Activity" {
                calories = (10*weight + 6.25*height - 5*age + 5) * 1.375
            }else if user.activity == "Moderate Activity" {
                calories = (10*weight + 6.25*height - 5*age + 5) * 1.55
            } else if user.activity == "Heavy Activity"{
                calories = (10*weight + 6.25*height - 5*age + 5) * 1.95
            }
        } else if user.gender == "Female" {
            if user.activity == "Light Activity" {
                calories = (10*weight + 6.25*height - 5*age - 161) * 1.375
            }else if user.activity == "Moderate Activity" {
                calories = (10*weight + 6.25*height - 5*age - 161) * 1.55
            } else if user.activity == "Heavy Activity"{
                calories = (10*weight + 6.25*height - 5*age - 161) * 1.95
            }
        }
        appDelegate.calorie = calories
    }
    //Below segue method presents different view controllers based different segue identifies
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "breakfastSegue" {
            let breakfastTVC: BreakfastTableViewController = segue.destinationViewController as! BreakfastTableViewController
            breakfastTVC.foodInfo = ParseOperations.breakfastData.sort({ $0.itemName < $1.itemName})
            breakfastTVC.breakfastIntakeCalories = parseOperations.breakfastIntake
        } else if segue.identifier == "lunchSegue" {
            let lunchTVC: LunchTableViewController = segue.destinationViewController as! LunchTableViewController
            lunchTVC.foodInfo = ParseOperations.lunchData.sort({ $0.itemName < $1.itemName})
            lunchTVC.lunchIntakeCalories = parseOperations.lunchIntake
        } else if segue.identifier == "dinnerSegue" {
            let dinnerTVC: DinnerTableViewController = segue.destinationViewController as! DinnerTableViewController
            dinnerTVC.foodInfo = ParseOperations.dinnerData.sort({ $0.itemName < $1.itemName})
            dinnerTVC.dinnerIntakeCalories = parseOperations.dinnerIntake
        } else if segue.identifier == "lateNightSegue"{
            let lateNightTVC: LateNightTableViewController = segue.destinationViewController as! LateNightTableViewController
            lateNightTVC.foodInfo = ParseOperations.lateNightData.sort({ $0.itemName < $1.itemName})
            lateNightTVC.lateNightIntakeCalories = parseOperations.dinnerIntake        }
    }
    // Below method populates alert
    func displayAlertWithTitle(title:String, message:String) {
        let uiAlertController:UIAlertController = UIAlertController(title: title,
                                                                    message: message, preferredStyle: UIAlertControllerStyle.Alert)
        uiAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel,
            handler:  nil))
        if presentedViewController == nil {
            self.presentViewController(uiAlertController, animated: true, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

