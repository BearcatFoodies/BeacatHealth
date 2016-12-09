//
//  FavoritesTableViewController.swift
//  BearcatHealth
//
//  Created by Ritish, Bandi on 10/7/16.
//  Copyright © 2016 Gayam,Prathibha. All rights reserved.
//
import UIKit
import Parse
import Bolts
//This class describes about the favourites table view controller functionality
class FavoritesTableViewController: UITableViewController {
    // Below variables are used to prepare data to choose favorites TVC
    var selected: Bool = false
    var selectedIndexPath:Int = 0
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var parseOperations = ParseOperations()
    var favoritesData:[FoodData] = []
    var  breakfastData:[FoodData] = []
    var lunchData:[FoodData] = []
    var dinnerData:[FoodData] = []
    var lateNightData:[FoodData] = []
    //Below variables refer to data received from the choose favorites TVC
    var  favoriteBreakfast:[FavoritesData] = []
    var favoriteLunch:[FavoritesData] = []
    var favoriteDinner:[FavoritesData] = []
    var favoriteLateNight:[FavoritesData] = []
    var  retrievedData:[FoodData] = []
    var addedBreakfastItems:[String] = []
    var addedLunchItems:[String] = []
    var addedDinnerItems:[String] = []
    var addedLateNightItems:[String] = []
    // These values stores the selected values
    //Selected Favorite data . These are with SID. Above values are objects of Food data.Just appending SID
    var selectedFavoriteBreakfastIntake:FavoritesData = FavoritesData()
    var selectedFavoriteLunchIntake:FavoritesData = FavoritesData()
    var selectedFavoriteDinnerIntake:FavoritesData = FavoritesData()
    var selectedFavoriteLateNightIntake:FavoritesData = FavoritesData()
    @IBOutlet var favoritesTableView: UITableView!
    override func viewDidLoad() {
        parseOperations = ParseOperations()
        // fetch Data from favorites table
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {

        parseOperations.retrieveFavoriteBreakFastMenu(appDelegate.userName)
        parseOperations.retrieveFavoriteLunchMenu(appDelegate.userName)
        parseOperations.retrieveFavoriteDinnerMenu(appDelegate.userName)
        parseOperations.retrieveFavoriteLateNightMenu(appDelegate.userName)
      
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(favoritesIsHere(_:)), name: "Favorites Dinner Is Served", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(favoritesIsHere(_:)), name: "Favorites Breakfast Is Served", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(favoritesIsHere(_:)), name: "Favorites Lunch Is Served", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(favoritesIsHere(_:)), name: "Favorites LateNight Is Served", object: nil)
    }
    func favoritesIsHere(notification:NSNotification) {
        self.favoriteBreakfast = parseOperations.favoriteBreakfast.sort({ $0.itemName < $1.itemName})
        self.favoriteLunch = parseOperations.favoriteLunch.sort({ $0.itemName < $1.itemName})
        self.favoriteDinner = parseOperations.favoriteDinner.sort({ $0.itemName < $1.itemName})
        self.favoriteLateNight = parseOperations.favoriteLateNight.sort({ $0.itemName < $1.itemName})
        favoritesTableView.reloadData()
    }
    //return the number of sections in a table
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    // returns number of rows in a section
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if favoriteBreakfast.count == 0{
                return 0
            }else{
                return favoriteBreakfast.count
            }
        } else if section == 1 {
            if favoriteLunch.count == 0{
                return 0
            }else{
                return favoriteLunch.count
            }
        } else if section == 2{
            if favoriteDinner.count == 0{
                return 0
            }else{
                return favoriteDinner.count
            }
        }else {
            if favoriteLateNight.count == 0{
                return 0
            }else{
                return favoriteLateNight.count
            }
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Favorites", forIndexPath: indexPath)
        let dishNameLBL:UILabel = cell.viewWithTag(100) as! UILabel
        let dishCaloriesLBL:UILabel = cell.viewWithTag(102) as! UILabel
        let dishIV:UIImageView = cell.viewWithTag(101) as! UIImageView
        // Configure the cell...
        if indexPath.section == 0 {
            dishNameLBL.text = favoriteBreakfast[indexPath.row].itemName
            dishCaloriesLBL.text = String(favoriteBreakfast[indexPath.row].calories) + " cal"
            dishIV.image = UIImage(named:"\(self.favoriteBreakfast[indexPath.row].itemName).jpg")
        } else if indexPath.section == 1 {
            dishNameLBL.text = favoriteLunch[indexPath.row].itemName
            dishCaloriesLBL.text = String(favoriteLunch[indexPath.row].calories) + " cal"
            dishIV.image = UIImage(named:"\(self.favoriteLunch[indexPath.row].itemName).jpg")
        } else if indexPath.section == 2{
            dishNameLBL.text = favoriteDinner[indexPath.row].itemName
            dishCaloriesLBL.text = String(favoriteDinner[indexPath.row].calories) + " cal"
            dishIV.image = UIImage(named:"\(self.favoriteDinner[indexPath.row].itemName).jpg")
        } else {
            dishNameLBL.text = favoriteLateNight[indexPath.row].itemName
            dishCaloriesLBL.text = String(favoriteLateNight[indexPath.row].calories) + " cal"
            dishIV.image = UIImage(named:"\(self.favoriteLateNight[indexPath.row].itemName).jpg")
        }
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       

        if indexPath.section == 0 {
            selectedFavoriteBreakfastIntake = favoriteBreakfast[indexPath.row]
        } else if indexPath.section == 1{
            selectedFavoriteLunchIntake = favoriteLunch[indexPath.row]
        } else if indexPath.section == 2 {
            selectedFavoriteDinnerIntake = favoriteDinner[indexPath.row]
            
        } else {
            
            
            
            
            selectedFavoriteLateNightIntake = favoriteLateNight[indexPath.row]
            
        }
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
     
        
        if indexPath.section == 0 {
            selectedFavoriteBreakfastIntake = FavoritesData()
        } else if indexPath.section == 1 {
            selectedFavoriteLunchIntake = FavoritesData()
        } else if indexPath.section == 2 {
            selectedFavoriteDinnerIntake = FavoritesData()
        } else {
            selectedFavoriteLateNightIntake = FavoritesData()
        }
    }
    @IBAction func cancelFavorites(segue:UIStoryboardSegue) {
    }
    @IBAction func saveFavoritesData(segue:UIStoryboardSegue) {
        favoritesTableView.reloadData()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "chooseFavorites" {
            let choseFavoritesTVC: ChooseFavoritesTableViewController = segue.destinationViewController as! ChooseFavoritesTableViewController
            self.navigationItem.title = "Favorites"
            choseFavoritesTVC.breakfast = ParseOperations.breakfastData.sort({ $0.itemName < $1.itemName})
            choseFavoritesTVC.lunch = ParseOperations.lunchData.sort({ $0.itemName < $1.itemName})
            choseFavoritesTVC.dinner = ParseOperations.dinnerData.sort({ $0.itemName < $1.itemName})
            choseFavoritesTVC.lateNight = ParseOperations.lateNightData.sort({ $0.itemName < $1.itemName})
            // These variables are used to check whether data is already present in databse so that we can populate an alert
            choseFavoritesTVC.favoriteBreakfast = self.favoriteBreakfast
            choseFavoritesTVC.favoriteLunch = self.favoriteLunch
            choseFavoritesTVC.favoriteDinner = self.favoriteDinner
            choseFavoritesTVC.favoriteLateNight = self.favoriteLateNight
        } else if segue.identifier == "editFavorites" {
            let editFaVoritesTVC: EditFavoriteTableViewController = segue.destinationViewController as! EditFavoriteTableViewController
            editFaVoritesTVC.favoriteBreakfast = self.favoriteBreakfast
            editFaVoritesTVC.favoriteLunch = self.favoriteLunch
            editFaVoritesTVC.favoriteDinner = self.favoriteDinner
            editFaVoritesTVC.favoriteLateNight = self.favoriteLateNight
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func addCalories(sender: UIBarButtonItem) {
        if selectedFavoriteBreakfastIntake.calories == 0 && selectedFavoriteLunchIntake.calories == 0 && selectedFavoriteDinnerIntake.calories == 0 && selectedFavoriteLateNightIntake.calories == 0  {
            displayAlertWithTitle("", message: "Please select at least one item to add calories")
            return
        }
        if selectedFavoriteBreakfastIntake.calories != 0 {
            addBreakfastCalories()
        }
        if selectedFavoriteLunchIntake.calories != 0 {
            addLunchCalories()
        }
        if selectedFavoriteDinnerIntake.calories != 0 {
            addDinnerCalories()
        }
        if selectedFavoriteLateNightIntake.calories != 0 {
            addlateNightCalories()
        }
    }
    func favoritesAdded(notification:NSNotification){
        displayAlertWithTitle("", message: "Added to Favorites")
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
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel!.textColor = UIColor.blackColor()
        header.textLabel!.font = UIFont(name: "Futura", size: 25)!
    }
    func addBreakfastCalories() {
        let selectCalorieIntake = CaloriesData()
        selectCalorieIntake.itemName = selectedFavoriteBreakfastIntake.itemName
        selectCalorieIntake.calories = selectedFavoriteBreakfastIntake.calories
        selectCalorieIntake.dayServed = selectedFavoriteBreakfastIntake.dayServed
        selectCalorieIntake.location = selectedFavoriteBreakfastIntake.location
        selectCalorieIntake.mealType = selectedFavoriteBreakfastIntake.mealType
        selectCalorieIntake.sid = selectedFavoriteBreakfastIntake.sid
        for item in BreakfastTableViewController.breakfastItems {
            addedBreakfastItems.append(item)
        }
        if addedBreakfastItems.contains(selectedFavoriteBreakfastIntake.itemName) {
            let addAlert = UIAlertController(title: "", message: "\(selectedFavoriteBreakfastIntake.itemName) is already present.Do you wish to add it again.", preferredStyle: UIAlertControllerStyle.Alert)
            addAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
                self.appDelegate.breakfastIntakeCalories += self.selectedFavoriteBreakfastIntake.calories
                self.parseOperations.saveCalorieIntake(selectCalorieIntake)
                BreakfastTableViewController.breakfastItems .append(self.selectedFavoriteBreakfastIntake.itemName)
                self.selectedFavoriteBreakfastIntake = FavoritesData()
                self.performSegueWithIdentifier("favoriteCalories", sender: self)
            }))
            addAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { action in
                return
            }))
            if presentedViewController ==  nil{
                self.presentViewController(addAlert, animated: true, completion: nil)
            }
        } else {
            self.appDelegate.breakfastIntakeCalories += self.selectedFavoriteBreakfastIntake.calories
            self.parseOperations.saveCalorieIntake(selectCalorieIntake)
            BreakfastTableViewController.breakfastItems.append(self.selectedFavoriteBreakfastIntake.itemName)
            self.selectedFavoriteBreakfastIntake = FavoritesData()
            self.performSegueWithIdentifier("favoriteCalories", sender: self)
        }
    }
    func addLunchCalories() {
        let selectCalorieIntake = CaloriesData()
        selectCalorieIntake.itemName = selectedFavoriteLunchIntake.itemName
        selectCalorieIntake.calories = selectedFavoriteLunchIntake.calories
        selectCalorieIntake.dayServed = selectedFavoriteLunchIntake.dayServed
        selectCalorieIntake.location = selectedFavoriteLunchIntake.location
        selectCalorieIntake.mealType = selectedFavoriteLunchIntake.mealType
        selectCalorieIntake.sid = selectedFavoriteLunchIntake.sid
        for item in MenuViewController.lunchIntakeCalories {
            addedLunchItems.append(item.itemName)
        }
        if addedLunchItems.contains(selectedFavoriteLunchIntake.itemName) {
            let addAlert = UIAlertController(title: "", message: "\(selectedFavoriteLunchIntake.itemName) is already present.Do you wish to add it again.", preferredStyle: UIAlertControllerStyle.Alert)
            addAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
                self.appDelegate.lunchIntakeCalories += self.selectedFavoriteLunchIntake.calories
                self.parseOperations.saveCalorieIntake(selectCalorieIntake)
                self.addedLunchItems.append(self.selectedFavoriteLunchIntake.itemName)
                self.selectedFavoriteLunchIntake = FavoritesData()
                self.performSegueWithIdentifier("favoriteCalories", sender: self)
            }))
            addAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { action in
                return
            }))
            if presentedViewController ==  nil{
                self.presentViewController(addAlert, animated: true, completion: nil)
            }
        } else {
            self.appDelegate.lunchIntakeCalories += self.selectedFavoriteLunchIntake.calories
            self.parseOperations.saveCalorieIntake(selectCalorieIntake)
            self.addedLunchItems.append(self.selectedFavoriteLunchIntake.itemName)
            self.selectedFavoriteLunchIntake = FavoritesData()
            self.performSegueWithIdentifier("favoriteCalories", sender: self)
        }
    }
    func addDinnerCalories() {
        let selectCalorieIntake = CaloriesData()
        selectCalorieIntake.itemName = selectedFavoriteDinnerIntake.itemName
        selectCalorieIntake.calories = selectedFavoriteDinnerIntake.calories
        selectCalorieIntake.dayServed = selectedFavoriteDinnerIntake.dayServed
        selectCalorieIntake.location = selectedFavoriteDinnerIntake.location
        selectCalorieIntake.mealType = selectedFavoriteDinnerIntake.mealType
        selectCalorieIntake.sid = selectedFavoriteDinnerIntake.sid
        for item in MenuViewController.dinnerIntakeCalories {
            addedDinnerItems.append(item.itemName)
        }
        if addedDinnerItems.contains(selectedFavoriteDinnerIntake.itemName) {
            let addAlert = UIAlertController(title: "", message: "\(selectedFavoriteDinnerIntake.itemName) is already present.Do you wish to add it again.", preferredStyle: UIAlertControllerStyle.Alert)
            addAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
                self.appDelegate.dinnerIntakeCalories += self.selectedFavoriteDinnerIntake.calories
                self.parseOperations.saveCalorieIntake(selectCalorieIntake)
                self.addedDinnerItems.append(self.selectedFavoriteDinnerIntake.itemName)
                self.selectedFavoriteDinnerIntake = FavoritesData()
                self.performSegueWithIdentifier("favoriteCalories", sender: self)
            }))
            addAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { action in
                return
            }))
            if presentedViewController ==  nil{
                self.presentViewController(addAlert, animated: true, completion: nil)
            }
        } else {
            self.appDelegate.dinnerIntakeCalories += self.selectedFavoriteDinnerIntake.calories
            self.addedDinnerItems.append(self.selectedFavoriteDinnerIntake.itemName)
            self.parseOperations.saveCalorieIntake(selectCalorieIntake)
            self.selectedFavoriteDinnerIntake = FavoritesData()
            self.performSegueWithIdentifier("favoriteCalories", sender: self)
        }
    }
    func addlateNightCalories() {
        let selectCalorieIntake = CaloriesData()
        selectCalorieIntake.itemName = selectedFavoriteLateNightIntake.itemName
        selectCalorieIntake.calories = selectedFavoriteLateNightIntake.calories
        selectCalorieIntake.dayServed = selectedFavoriteLateNightIntake.dayServed
        selectCalorieIntake.location = selectedFavoriteLateNightIntake.location
        selectCalorieIntake.mealType = selectedFavoriteLateNightIntake.mealType
        selectCalorieIntake.sid = selectedFavoriteLateNightIntake.sid
        for item in MenuViewController.lateNightIntakeCalories {
            addedLateNightItems.append(item.itemName)
        }
        if addedLateNightItems.contains(selectedFavoriteLateNightIntake.itemName) {
            let addAlert = UIAlertController(title: "", message: "\(selectedFavoriteLateNightIntake.itemName) is already present.Do you wish to add it again.", preferredStyle: UIAlertControllerStyle.Alert)
            addAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
                self.appDelegate.lateNightIntakeCalories += self.selectedFavoriteLateNightIntake.calories
                self.parseOperations.saveCalorieIntake(selectCalorieIntake)
                self.addedLateNightItems.append(self.selectedFavoriteLateNightIntake.itemName)
                self.selectedFavoriteLateNightIntake = FavoritesData()
                self.performSegueWithIdentifier("favoriteCalories", sender: self)
            }))
            addAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { action in
                return
            }))
            if presentedViewController ==  nil{
                self.presentViewController(addAlert, animated: true, completion: nil)
            }
        } else {
            self.appDelegate.lateNightIntakeCalories += self.selectedFavoriteLateNightIntake.calories
            self.parseOperations.saveCalorieIntake(selectCalorieIntake)
            addedLateNightItems.append(self.selectedFavoriteLateNightIntake.itemName)
            self.selectedFavoriteLateNightIntake = FavoritesData()
            self.performSegueWithIdentifier("favoriteCalories", sender: self)
        }
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 61.0
    }
    func displayAlertWithTitle(title:String, message:String){
        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction:UIAlertAction =  UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
