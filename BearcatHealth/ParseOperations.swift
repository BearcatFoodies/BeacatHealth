//
//  ParseOperations.swift
//  BearcatHealth
//
//  Created by Pachipulusu,Venkatakotianilkumar on 11/8/16.
//  Copyright © 2016 Gayam,Prathibha. All rights reserved.
//
import UIKit
import Bolts
import Parse
class ParseOperations {
    // Data for breakfast,lunch,dinner and latenight view controllers
    var breakfastData:[FoodData] = []
    var lunchData:[FoodData] = []
    var dinnerData:[FoodData] = []
    var lateNightData:[FoodData] = []
    var user : [Profile] = []
    // Data for favorites view controller
    var  favoriteBreakfast:[FavoritesData] = []
    var favoriteLunch:[FavoritesData] = []
    var favoriteDinner:[FavoritesData] = []
    var favoriteLateNight:[FavoritesData] = []
    // Calori Intake Variables
    var  breakfastIntake:[CaloriesData] = []
    var lunchIntake:[CaloriesData] = []
    var dinnerIntake:[CaloriesData] = []
    var lateNightIntake:[CaloriesData] = []
    // Retrives data from Food data table and if it is breakfast
    func retrieveBreakFastMenu(){
        let query = PFQuery(className:"FoodData")
        query.whereKey("mealType", equalTo:"Breakfast")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.breakfastData = objects as! [FoodData]
                NSNotificationCenter.defaultCenter().postNotificationName("Breakfast Is Served", object: nil)
            }
        }
    }
    // Retrives data from Food data table and if it is Lunch
    func retrieveLunchMenu()  {
        let query = PFQuery(className:"FoodData")
        query.whereKey("mealType", equalTo:"Lunch")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                
                self.lunchData = objects as! [FoodData]
                NSNotificationCenter.defaultCenter().postNotificationName("Lunch Is Served", object: nil)
            }
        }
    }
    // Retrives data from Food data table and if it is Dinner
    func retrieveDinnerMenu() {
        let query = PFQuery(className:"FoodData")
        query.whereKey("mealType", equalTo:"Dinner")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.dinnerData = objects as! [FoodData]
                NSNotificationCenter.defaultCenter().postNotificationName("Dinner Is Served", object: nil)
            }
        }
    }
    // Retrives data from Food data table and if it is LateNight
    func retrieveLateNightMenu()  {
        let query = PFQuery(className:"FoodData")
        query.whereKey("mealType", equalTo:"Late Night")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.lateNightData = objects as! [FoodData]
                NSNotificationCenter.defaultCenter().postNotificationName("lateNight Is Served", object: nil)
            }
        }
    }
    // Fetches the data from favorites table for breakfast
    func retrieveFavoriteBreakFastMenu(userName :String){
        let query = PFQuery(className:"FavoritesData")
        query.whereKey("mealType", equalTo:"Breakfast")
        query.whereKey("sid", equalTo:userName)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.favoriteBreakfast = objects as! [FavoritesData]
                NSNotificationCenter.defaultCenter().postNotificationName("Favorites Breakfast Is Served", object: nil)
            }
        }
    }
    // Fetches the data from favorites table for Lunch
    func retrieveFavoriteLunchMenu(userName :String) {
        let query = PFQuery(className:"FavoritesData")
        query.whereKey("mealType", equalTo:"Lunch")
        query.whereKey("sid", equalTo:userName)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.favoriteLunch = objects as! [FavoritesData]
                NSNotificationCenter.defaultCenter().postNotificationName("Favorites Lunch Is Served", object: nil)
            }
        }
    }
    // Fetches the data from favorites table for Dinner
    func retrieveFavoriteDinnerMenu(userName :String)  {
        let query = PFQuery(className:"FavoritesData")
        query.whereKey("mealType", equalTo:"Dinner")
        query.whereKey("sid", equalTo:userName)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.favoriteDinner = objects as! [FavoritesData]
                NSNotificationCenter.defaultCenter().postNotificationName("Favorites Dinner Is Served", object: nil)
            }
        }
    }
    // Fetches the data from favorites table for LateNight
    func retrieveFavoriteLateNightMenu(userName :String) {
        let query = PFQuery(className:"FavoritesData")
        query.whereKey("mealType", equalTo:"Late Night")
        query.whereKey("sid", equalTo:userName)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.favoriteLateNight = objects as! [FavoritesData]
                NSNotificationCenter.defaultCenter().postNotificationName("Favorites LateNight Is Served", object: nil)
            }
        }
    }
    //Allows to delete food items from favourite breakfast
    func deleteFavoriteBreakfast(itemName:String , userName :String) {
        let query = PFQuery(className: "FavoritesData")
        query.whereKey("itemName", equalTo: itemName).whereKey("mealType", equalTo:"Breakfast").whereKey("sid" , equalTo:userName)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    object.deleteEventually()
                }
                NSNotificationCenter.defaultCenter().postNotificationName("It's Not Tasty", object: nil)
            }
        }
    }
    //Allows to delete food items from favourite lunch
    func deleteFavoriteLunch(itemName:String, userName :String) {
        let query = PFQuery(className: "FavoritesData")
        query.whereKey("itemName", equalTo: itemName).whereKey("mealType", equalTo:"Lunch").whereKey("sid" , equalTo:userName)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    object.deleteEventually()
                }
                NSNotificationCenter.defaultCenter().postNotificationName("It's Not Tasty", object: nil)
            }
        }
    }
    //Allows to delete food items from favourite dinner
    func deleteFavoriteDinner(itemName:String, userName :String) {
        let query = PFQuery(className: "FavoritesData")
        query.whereKey("itemName", equalTo: itemName).whereKey("mealType", equalTo:"Dinner").whereKey("sid" , equalTo:userName)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    object.deleteEventually()
                }
                NSNotificationCenter.defaultCenter().postNotificationName("It's Not Tasty", object: nil)
            }
        }
    }
    //Allows to delete food items from favourite lastnight
    func deleteFavoriteLateNight(itemName:String, userName :String) {
        let query = PFQuery(className: "FavoritesData")
        query.whereKey("itemName", equalTo: itemName).whereKey("mealType", equalTo:"Late Night").whereKey("sid" , equalTo:userName)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    object.deleteEventually()
                }
                NSNotificationCenter.defaultCenter().postNotificationName("It's Not Tasty", object: nil)
            }
        }
    }
    //Allows to save favourite beakfast food items
    func saveFvaoriteBreakfastdata(favorites: FavoritesData) {
        favorites.saveInBackgroundWithBlock({ (success, error) -> Void in
            if success {
                NSNotificationCenter.defaultCenter().postNotificationName("Added to Favorites", object: nil)
            }
        })
    }
    //Allows to save favourite lunch food items
    func saveFvaoriteLunchdata(favorites: FavoritesData) {
        favorites.saveInBackgroundWithBlock({ (success, error) -> Void in
            if success {
                NSNotificationCenter.defaultCenter().postNotificationName("Added to Favorites", object: nil)           }
        })
    }
    //Allows to save favourite dinner food items
    func saveFvaoriteDinnerdata(favorites: FavoritesData) {
        favorites.saveInBackgroundWithBlock({ (success, error) -> Void in
            if success {
                NSNotificationCenter.defaultCenter().postNotificationName("Added to Favorites", object: nil)
            }
        })
    }
    //Allows to save favourite Latenight food items
    func saveFvaoriteLateNightdata(favorites: FavoritesData) {
        favorites.saveInBackgroundWithBlock({ (success, error) -> Void in
            if success {
                NSNotificationCenter.defaultCenter().postNotificationName("Added to Favorites", object: nil)
            }
        })
    }
    //Allows us to retrieve the user name
    func retrieveUser(userName :String)  {
        let query = PFQuery(className:"Profile")
        query.whereKey("sid", equalTo: userName)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.user = objects as! [Profile]
            }
            NSNotificationCenter.defaultCenter().postNotificationName("User retrived", object: nil)
        }
    }
    //save the number of calories consumed
    func saveCalorieIntake(intake: CaloriesData) {
        intake.saveInBackgroundWithBlock({(success,error) -> Void in
            if success {
                NSNotificationCenter.defaultCenter().postNotificationName("Added to CaloriIntake", object: nil)
            }
        })
    }
    //Allows us to retrieve the number of calories consumed in breakfast
    func retriveBreakfastCalorieIntake(userName:String) {
        let query = PFQuery(className: "CaloriesData")
        query.whereKey("sid", equalTo: userName)
        query.whereKey("mealType", equalTo:"Breakfast")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.breakfastIntake = objects as! [CaloriesData]
            }
            NSNotificationCenter.defaultCenter().postNotificationName("User breakfast calories retrived", object: nil)
        }
    }
    //Allows us to retrieve the number of calories consumed in lunch
    func retriveLunchCalorieIntake(userName:String) {
        let query = PFQuery(className: "CaloriesData")
        query.whereKey("sid", equalTo: userName)
        query.whereKey("mealType", equalTo:"Lunch")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.lunchIntake = objects as! [CaloriesData]
            }
            NSNotificationCenter.defaultCenter().postNotificationName("User lunch calories retrived", object: nil)
        }
    }
    //Allows us to retrieve the number of calories consumed in dinner
    func retriveDinnerCalorieIntake(userName:String) {
        let query = PFQuery(className: "CaloriesData")
        query.whereKey("sid", equalTo: userName)
        query.whereKey("mealType", equalTo:"Dinner")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.dinnerIntake = objects as! [CaloriesData]
            }
            NSNotificationCenter.defaultCenter().postNotificationName("User dinner calories retrived", object: nil)
        }
    }
    //Allows us to retrieve the number of calories consumed in late night
    func retriveLateNightCalorieIntake(userName:String) {
        let query = PFQuery(className: "CaloriesData")
        query.whereKey("sid", equalTo: userName)
        query.whereKey("mealType", equalTo:"Late Night")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.lateNightIntake = objects as! [CaloriesData]
            }
            NSNotificationCenter.defaultCenter().postNotificationName("User latenight calories retrived", object: nil)
        }
    }
    //Allows to clear the calorie consumed by the user
    func clearIntake(userName:String) {
        let query = PFQuery(className: "CaloriesData")
        query.whereKey("sid", equalTo: userName)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    object.deleteEventually()
                }
            }
        }
    }
}





