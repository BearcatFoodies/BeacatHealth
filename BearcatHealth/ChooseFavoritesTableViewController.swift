//
//  ChooseFavoritesTableViewController.swift
//  BearcatHealth
//
//  Created by Pachipulusu,Venkatakotianilkumar on 11/2/16.
//  Copyright © 2016 Gayam,Prathibha. All rights reserved.
//

import UIKit
import Parse
import Bolts
class ChooseFavoritesTableViewController:UITableViewController  {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var selected: Bool = false
    var parseOperations:ParseOperations!
    var selectedIndexPath:Int = 0
    @IBOutlet weak var tableview: UITableView!
    // These variables hold entire data of breakfast , lunch , dinner and latenight
    var breakfast:[FoodData] = []
    var lunch:[FoodData] = []
    var dinner:[FoodData] = []
    var lateNight:[FoodData] = []
    // These values stores the selected values
    var selectedBreakfastData:FoodData = FoodData()
    var selectedLunchData:FoodData = FoodData()
    var selectedDinnerData:FoodData = FoodData()
    var selectedLateNightData:FoodData = FoodData()
    //Selected Favorite data . These are with SID. Above values are objects of Food data.Just appending SID
    var selectedFavoriteBreakfastData:FavoritesData = FavoritesData()
    var selectedFavoriteLunchData:FavoritesData = FavoritesData()
    var selectedFavoriteDinnerData:FavoritesData = FavoritesData()
    var selectedFavoriteLateNightData:FavoritesData = FavoritesData()
    // Favorites which are already present in database
    var  favoriteBreakfast:[FavoritesData] = []
    var favoriteLunch:[FavoritesData] = []
    var favoriteDinner:[FavoritesData] = []
    var favoriteLateNight:[FavoritesData] = []
    //favorite items
    var favbreakfast:[String] = []
    var favLunch:[String] = []
    var favDinner : [String] = []
    var favLateNight: [String] = []
    override func viewDidLoad() {
        parseOperations = ParseOperations()
        super.viewDidLoad()
    }
    func foodIsHere(notification:NSNotification){
        self.tableView.reloadData()
    }
    override func viewWillAppear(animated: Bool) {
        for favorite in favoriteBreakfast {
            favbreakfast.append(favorite.itemName)
        }
        for favorite in favoriteLunch {
            favLunch.append(favorite.itemName)
        }
        for favorite in favoriteDinner {
            favDinner.append(favorite.itemName)
        }
        for favorite in favoriteLateNight {
            favLateNight.append(favorite.itemName)
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(foodIsHere(_:)), name: "lateNight Is Served", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(foodIsHere(_:)), name: "Favorites Breakfast Is Served", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(foodIsHere(_:)), name: "Favorites Lunch Is Served", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(foodIsHere(_:)), name: "Favorites Dinner Is Served", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(foodIsHere(_:)), name: "Favorites LateNight Is Served", object: nil)
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            selectedBreakfastData = breakfast[indexPath.row]
            selectedFavoriteBreakfastData.itemName = selectedBreakfastData.itemName
            selectedFavoriteBreakfastData.calories = selectedBreakfastData.calories
            selectedFavoriteBreakfastData.dayServed = selectedBreakfastData.dayServed
            selectedFavoriteBreakfastData.location = selectedBreakfastData.location
            selectedFavoriteBreakfastData.mealType = selectedBreakfastData.mealType
            selectedFavoriteBreakfastData.sid = appDelegate.userName
        } else if indexPath.section == 1{
            selectedLunchData = lunch[indexPath.row]
            selectedFavoriteLunchData.itemName = selectedLunchData.itemName
            selectedFavoriteLunchData.calories = selectedLunchData.calories
            selectedFavoriteLunchData.dayServed = selectedLunchData.dayServed
            selectedFavoriteLunchData.location           = selectedLunchData.location
            selectedFavoriteLunchData.mealType = selectedLunchData.mealType
            selectedFavoriteLunchData.sid  = appDelegate.userName
        } else if indexPath.section == 2 {
            selectedDinnerData = dinner[indexPath.row]
            selectedFavoriteDinnerData.itemName = selectedDinnerData.itemName
            selectedFavoriteDinnerData.calories = selectedDinnerData.calories
            selectedFavoriteDinnerData.dayServed = selectedDinnerData.dayServed
            selectedFavoriteDinnerData.location  = selectedDinnerData.location
            selectedFavoriteDinnerData.mealType = selectedDinnerData.mealType
            selectedFavoriteDinnerData.sid  = appDelegate.userName
        } else {
            selectedLateNightData = lateNight[indexPath.row]
            selectedFavoriteLateNightData.itemName = selectedLateNightData.itemName
            selectedFavoriteLateNightData.calories = selectedLateNightData.calories
            selectedFavoriteLateNightData.dayServed = selectedLateNightData.dayServed
            selectedFavoriteLateNightData.location  = selectedLateNightData.location
            selectedFavoriteLateNightData.mealType = selectedLateNightData.mealType
            selectedFavoriteLateNightData.sid  = appDelegate.userName
        }
    }
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType =
            UITableViewCellAccessoryType.None
        if indexPath.section == 0 {
            selectedBreakfastData = FoodData()
        } else if indexPath.section == 1{
            selectedLunchData = FoodData()
        } else if indexPath.section == 2 {
            selectedDinnerData = FoodData()
        } else {
            selectedLateNightData = FoodData()
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //return the number of sections in a table
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    //return the number of rows
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if breakfast.count == 0{
                return 0
            }else{
                return breakfast.count
            }
        } else if section == 1 {
            if lunch.count == 0{
                return 0
            }else{
                return lunch.count
            }
        } else if section == 2{
            if dinner.count == 0{
                return 0
            }else{
                return dinner.count
            }
        }else {
            if lateNight.count == 0{
                return 0
            }else{
                return lateNight.count
            }
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("chooseFavorites", forIndexPath: indexPath)
        let dishNameLBL:UILabel = cell.viewWithTag(101) as! UILabel
        let dishCaloriesLBL:UILabel = cell.viewWithTag(102) as! UILabel
        let dishIV:UIImageView = cell.viewWithTag(100) as! UIImageView
        // Configure the cell...
        if indexPath.section == 0 {
            dishNameLBL.text = breakfast[indexPath.row].itemName
            dishCaloriesLBL.text = String(breakfast[indexPath.row].calories ) + " cal"
            dishIV.image = UIImage(named:"\(breakfast[indexPath.row].itemName).jpg")
        } else if indexPath.section == 1 {
            dishNameLBL.text = lunch[indexPath.row].itemName
            dishCaloriesLBL.text = String(lunch[indexPath.row].calories) + " cal"
            dishIV.image = UIImage(named:"\(lunch[indexPath.row].itemName).jpg")
        } else if indexPath.section == 2{
            dishNameLBL.text = dinner[indexPath.row].itemName
            dishCaloriesLBL.text = String(dinner[indexPath.row].calories) + " cal"
            dishIV.image = UIImage(named:"\(dinner[indexPath.row].itemName).jpg")
        } else {
            dishNameLBL.text = lateNight[indexPath.row].itemName
            dishCaloriesLBL.text = String(lateNight[indexPath.row].calories) + " cal"
            dishIV.image = UIImage(named:"\(lateNight[indexPath.row].itemName).jpg")
        }
        return cell
    }
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel!.textColor = UIColor.blackColor()
        header.textLabel!.font = UIFont(name: "Futura", size: 25)!
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Breakfast"
        } else if section == 1{
            return "Lunch"
        } else if section == 2 {
            return "Dinner"
        } else {
            return "Latenight"
        }
    }
    @IBAction func addToFavorites(sender: UIBarButtonItem) {
        if selectedBreakfastData.calories == 0 && selectedLunchData.calories == 0 && selectedDinnerData.calories == 0 && selectedLateNightData.calories == 0  {
            displayAlertWithTitle("", message: "Please select at least one item to add into favorites")
        }
        if  selectedBreakfastData.calories != 0  {
            addFavBreakfast()
        }
        if selectedLunchData.calories != 0 {
            addFavLunch()
        }
        if selectedDinnerData.calories != 0 {
            addFavDinner()
        }
        if selectedLateNightData.calories != 0 {
            addFavLateNight()
        }
    }
    func favoritesAdded(notification:NSNotification){
        displayAlertWithTitle("", message: "Added to Favorites")
    }
    func addFavBreakfast() {
        if favbreakfast.contains(selectedBreakfastData.itemName) {
            displayAlertWithTitle("", message: "Already Present in Favorites")
            return
        } else {
            parseOperations.saveFvaoriteBreakfastdata(selectedFavoriteBreakfastData)
            favbreakfast.append(selectedFavoriteBreakfastData.itemName)
            displayFavoriteAdded("",message:"\(selectedFavoriteBreakfastData.itemName) is added to favorites")
        }
    }
    func addFavLunch() {
        if favLunch.contains(selectedLunchData.itemName) {
            displayAlertWithTitle("", message: "Already Present in Favorites")
            return
        } else {
            parseOperations.saveFvaoriteLunchdata(selectedFavoriteLunchData)
            favLunch.append(selectedFavoriteLunchData.itemName)
            displayFavoriteAdded("",message:"\(selectedFavoriteLunchData.itemName) is added to favorites")
            
            performSegueWithIdentifier("addedFavorites", sender: self)
        }
    }
    func addFavDinner() {
        if favDinner.contains(selectedDinnerData.itemName) {
            displayAlertWithTitle("", message: "Already Present in Favorites")
            return
        } else {
            parseOperations.saveFvaoriteDinnerdata(selectedFavoriteDinnerData)
            displayFavoriteAdded("",message:"\(selectedFavoriteDinnerData.itemName) is added to favorites")
            
            favDinner.append(selectedFavoriteDinnerData.itemName)
        }
    }
    func addFavLateNight() {
        if favLateNight.contains(selectedLateNightData.itemName ) {
            displayAlertWithTitle("", message: "Already Present in Favorites")
            return
        } else {
            parseOperations.saveFvaoriteLateNightdata(selectedFavoriteLateNightData)
            displayFavoriteAdded("",message:"\(selectedFavoriteLateNightData.itemName) is added to favorites")
            favLateNight.append(selectedFavoriteLateNightData.itemName)
        }
    }
    func displayAlertWithTitle(title:String, message:String){
        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction:UIAlertAction =  UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        if presentedViewController ==  nil{
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    func displayFavoriteAdded(title:String , message: String) {
        
        let addAlert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        addAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            
            self.performSegueWithIdentifier("addedFavorites", sender: self)
        }))
        
        if presentedViewController ==  nil{
            self.presentViewController(addAlert, animated: true, completion: nil)
        }
    }
}
