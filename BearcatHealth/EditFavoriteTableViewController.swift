//
//  EditFavoriteTableViewController.swift
//  BearcatHealth
//
//  Created by Pachipulusu,Venkatakotianilkumar on 11/9/16.
//  Copyright © 2016 Gayam,Prathibha. All rights reserved.
//

import UIKit
import Parse
import Bolts
class EditFavoriteTableViewController: UITableViewController {
    // MARK: - properties
    // A property which allows us to access Appdelegate data
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    // An outlet for editfavorites table view controller
    @IBOutlet var editFavoritesTVC: UITableView!
    // An object for parseoperations
    let parseOperations:ParseOperations = ParseOperations()
    // Below variables holds user favorite breakfast,lunch,dinner and latenight
    var favoriteBreakfast:[FavoritesData] = []
    var favoriteLunch:[FavoritesData] = []
    var favoriteDinner:[FavoritesData] = []
    var favoriteLateNight:[FavoritesData] = []
    // This property holds from which section data need to be deleted
    var deleteSection = 0
    // This property holds which row need to be deleted from favorites
    var deleteRow = 0
    var deleteSelectedIndexPath: NSIndexPath? = nil
    // MARK: - Default methoods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        parseOperations.retrieveFavoriteBreakFastMenu(appDelegate.userName)
        parseOperations.retrieveFavoriteLunchMenu(appDelegate.userName)
        parseOperations.retrieveFavoriteDinnerMenu(appDelegate.userName)
        parseOperations.retrieveFavoriteLateNightMenu(appDelegate.userName)
        favoriteBreakfast = parseOperations.favoriteBreakfast
        favoriteLunch = parseOperations.favoriteLunch
        favoriteDinner = parseOperations.favoriteDinner
        favoriteLateNight = parseOperations.favoriteLateNight
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(favoritesIsHere(_:)), name: "Favorites Breakfast Is Served", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(favoritesIsHere(_:)), name: "Favorites Dinner Is Served", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(favoritesIsHere(_:)), name: "Favorites Lunch Is Served", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(favoritesIsHere(_:)), name: "Favorites LateNight Is Served", object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Notification handler
    // It reloads table view once favorites data retrieved notification is received
    func favoritesIsHere(notification:NSNotification) {
        self.favoriteBreakfast = parseOperations.favoriteBreakfast
        self.favoriteLunch = parseOperations.favoriteLunch
        self.favoriteDinner = parseOperations.favoriteDinner
        self.favoriteLateNight = parseOperations.favoriteLateNight
        editFavoritesTVC.reloadData()
    }
    // MARK: - Table view methods
    //return the number of sections in a table
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    // Method sets the size and font of text in the header of a tableview
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel!.textColor = UIColor.blackColor()
        header.textLabel!.font = UIFont(name: "Futura", size: 25)!
    }
    //return the number of rows in each section
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
    // This method allows to edit tableview cell
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    // This method provides delete option for the user if table view cell is swiped
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handles delete (by removing the data from array and updating the tableview)
            var favoriteToDelete = FavoritesData()
            if indexPath.section == 0 {
                favoriteToDelete = favoriteBreakfast[indexPath.row]
                deleteSection = indexPath.section
                deleteRow = indexPath.row
            } else if indexPath.section == 1 {
                favoriteToDelete = favoriteLunch[indexPath.row]
                deleteSection = indexPath.section
                deleteRow = indexPath.row
            } else if indexPath.section == 2 {
                favoriteToDelete = favoriteDinner[indexPath.row]
                deleteSection = indexPath.section
                deleteRow = indexPath.row
            } else {
                favoriteToDelete = favoriteLateNight[indexPath.row]
                deleteSection = indexPath.section
                deleteRow = indexPath.row
            }
            confirmDelete(favoriteToDelete)
        }
    }
    // Loads data into tableview cell
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
    // sets the header for each section
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
    // MARK: - Swipe delete
    // Displays an alert to the user if user selcets delete option
    func confirmDelete(Favorite: FavoritesData ) {
        let alert = UIAlertController(title: "Delete Favorite", message: "You want to permanently delete \(Favorite.itemName)? from Favorite list", preferredStyle: .Alert)
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: handleDeleteFavorite)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDeleteFavorite)
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    // This method deletes the selected item from favorites abnd reloads the table view
    func handleDeleteFavorite(alertAction: UIAlertAction!) -> Void {
        if deleteSection == 0 {
            parseOperations.deleteFavoriteBreakfast(favoriteBreakfast[deleteRow].itemName , userName: appDelegate.userName)
            favoriteBreakfast.removeAtIndex(deleteRow)
            editFavoritesTVC.reloadData()
        } else if deleteSection == 1 {
            parseOperations.deleteFavoriteLunch(favoriteLunch[deleteRow].itemName , userName: appDelegate.userName)
            favoriteLunch.removeAtIndex(deleteRow)
            editFavoritesTVC.reloadData()
            
        } else if deleteSection == 2 {
            parseOperations.deleteFavoriteDinner(favoriteDinner[deleteRow].itemName , userName: appDelegate.userName)
            favoriteDinner.removeAtIndex(deleteRow)
            editFavoritesTVC.reloadData()
        } else {
            parseOperations.deleteFavoriteLateNight(favoriteLateNight[deleteRow].itemName , userName: appDelegate.userName)
            favoriteDinner.removeAtIndex(deleteRow)
            editFavoritesTVC.reloadData()
        }
    }
    // this method resets the selected index to nil if user skips delete option and selects cancel from the alert is displayed to delete favorite
    func cancelDeleteFavorite(alertAction: UIAlertAction!) {
        deleteSelectedIndexPath = nil
        editFavoritesTVC.reloadData()
    }
    
}
