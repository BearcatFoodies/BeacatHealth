//
//  AppDelegate.swift
//  BearcatHealth
//
//  Created by Gayam,Prathibha on 10/6/16.
//  Copyright © 2016 Gayam,Prathibha. All rights reserved.
//
import UIKit
import Parse
import Bolts
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var  breakfast:[FoodData] = []
    var lunch:[FoodData] = []
    var dinner:[FoodData] = []
    var lateNight : [FoodData] = []
    var window: UIWindow?
    var calorie = 0.0
    var userName = ""
    var password = ""
    var  breakfastIntakeCalories = 0
    var lunchIntakeCalories = 0
    var dinnerIntakeCalories = 0
    var lateNightIntakeCalories = 0
    var user:Profile!
    //var logindetails = LoginViewController()
    let parseOperations = ParseOperations()
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        temporary.registerSubclass()
        Profile.registerSubclass()
        FoodData.registerSubclass()
        PFUser.registerSubclass()
        FavoritesData.registerSubclass()
        CaloriesData.registerSubclass()
        let configuration = ParseClientConfiguration {
            $0.applicationId = "oxgrUYMR9ANREChXSxDOCQPOYPFM4bwGipdeDLKQ"
            $0.clientKey = "pVNkEvs6FawuUA1YKELSUqcN7iSH9c6Lq5CseP4h"
            $0.server = "https://parseapi.back4app.com"
        }
        Parse.initializeWithConfiguration(configuration)
        return true
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

