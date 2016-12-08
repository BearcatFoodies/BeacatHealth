//
//  FirstViewController.swift
//  BearcatHealth
//
//  Created by Gayam,Prathibha on 10/6/16.
//  Copyright © 2016 Gayam,Prathibha. All rights reserved.
import UIKit
import Parse
class MenuViewController: UIViewController {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var parseOperations:ParseOperations!
    var  breakfastData:[FoodData] = []
    var lunchData:[FoodData] = []
    var dinnerData:[FoodData] = []
    var lateNightData:[FoodData] = []
    var user = Profile()
    var users:[Profile] = []
    static var userscount  = 0
    static var  breakfastIntakeCalories:[CaloriesData] = []
    static var lunchIntakeCalories:[CaloriesData] = []
    static var dinnerIntakeCalories:[CaloriesData] = []
    static var lateNightIntakeCalories:[CaloriesData] = []
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "hotel-dining.jpg")!)
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
    override func viewWillAppear(animated: Bool) {
        parseOperations.retrieveBreakFastMenu()
        parseOperations.retrieveLunchMenu()
        parseOperations.retrieveDinnerMenu()
        parseOperations.retrieveLateNightMenu()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
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
    func breakfastCaloriesHere(notification:NSNotification){
        MenuViewController.breakfastIntakeCalories = parseOperations.breakfastIntake
        for calori in MenuViewController.breakfastIntakeCalories {
            appDelegate.breakfastIntakeCalories += calori.calories
        }
    }
    func lunchCaloriesHere(notification:NSNotification){
        MenuViewController.lunchIntakeCalories = parseOperations.lunchIntake
        for calori in MenuViewController.lunchIntakeCalories {
            appDelegate.lunchIntakeCalories += calori.calories
        }
    }
    func dinnerCaloriesHere(notification:NSNotification){
        MenuViewController.dinnerIntakeCalories = parseOperations.dinnerIntake
        for calori in MenuViewController.dinnerIntakeCalories {
            appDelegate.dinnerIntakeCalories += calori.calories
        }
    }
    func lateNightCaloriesHere(notification:NSNotification){
        MenuViewController.lateNightIntakeCalories = parseOperations.lateNightIntake
        for calori in MenuViewController.lateNightIntakeCalories {
            appDelegate.lateNightIntakeCalories += calori.calories
        }
    }
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "breakfastSegue" {
            let breakfastTVC: BreakfastTableViewController = segue.destinationViewController as! BreakfastTableViewController
            breakfastTVC.foodInfo = parseOperations.breakfastData
            breakfastTVC.breakfastIntakeCalories = parseOperations.breakfastIntake
        } else if segue.identifier == "lunchSegue" {
            let lunchTVC: LunchTableViewController = segue.destinationViewController as! LunchTableViewController
            lunchTVC.foodInfo = parseOperations.lunchData
            lunchTVC.lunchIntakeCalories = parseOperations.lunchIntake
        } else if segue.identifier == "dinnerSegue" {
            let dinnerTVC: DinnerTableViewController = segue.destinationViewController as! DinnerTableViewController
            dinnerTVC.foodInfo = parseOperations.dinnerData
            dinnerTVC.dinnerIntakeCalories = parseOperations.dinnerIntake
        } else if segue.identifier == "lateNightSegue"{
            let lateNightTVC: LateNightTableViewController = segue.destinationViewController as! LateNightTableViewController
            lateNightTVC.foodInfo = parseOperations.lateNightData
            lateNightTVC.lateNightIntakeCalories = parseOperations.dinnerIntake
        }
    }
}

