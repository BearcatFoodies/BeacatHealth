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
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var deleteSection = 0
    var deleteRow = 0
    @IBOutlet var editFavoritesTVC: UITableView!
    let parseOperations:ParseOperations = ParseOperations()
    var  favoriteBreakfast:[FavoritesData] = []
    var favoriteLunch:[FavoritesData] = []
    var favoriteDinner:[FavoritesData] = []
    var favoriteLateNight:[FavoritesData] = []
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
    func favoritesIsHere(notification:NSNotification) {
        self.favoriteBreakfast = parseOperations.favoriteBreakfast
        self.favoriteLunch = parseOperations.favoriteLunch
        self.favoriteDinner = parseOperations.favoriteDinner
        self.favoriteLateNight = parseOperations.favoriteLateNight
        editFavoritesTVC.reloadData()
    }
    @IBAction func deleteBTN(sender: UIButton) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //return the number of sections in a table
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
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
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
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
    func confirmDelete(Favorite: FavoritesData ) {
        let alert = UIAlertController(title: "Delete Favorite", message: "You want to permanently delete \(Favorite.itemName)? from Favorite list", preferredStyle: .Alert)
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: handleDeleteFavorite)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDeleteFavorite)
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    var deletePlanetIndexPath: NSIndexPath? = nil
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
    func cancelDeleteFavorite(alertAction: UIAlertAction!) {
        deletePlanetIndexPath = nil
        editFavoritesTVC.reloadData()
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
}
