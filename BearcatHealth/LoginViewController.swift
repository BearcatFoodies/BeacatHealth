//
//  LoginViewController.swift
//  BearcatHealth
//
//  Created by Pachipulusu,Venkatakotianilkumar on 11/14/16.
//  Copyright © 2016 Gayam,Prathibha. All rights reserved.
//
import UIKit
import Parse
import Bolts

// This view controller provides the functionality for login view
class LoginViewController: UIViewController{
    
    // This is the outlet for activity indicator
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    // This variable is created to use Appdelegate data
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    // This is the outlet for username 
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBAction func login(sender: UIButton) {
        self.activityIndicatorView.startAnimating()
        appDelegate.userName = userNameTF.text!
        PFUser.logInWithUsernameInBackground(userNameTF.text!, password: passwordTF.text!, block : {(user,error)-> Void in
            self.activityIndicatorView.stopAnimating()
            if error == nil {
                self.activityIndicatorView.startAnimating()
                self.onSuccess()
            }
            else {
                self.onFailure()
            }
        })
    }
    @IBAction func backToLogin(segue:UIStoryboardSegue){
        appDelegate.user = Profile()
        PFUser.logOut()
    }
    func onSuccess() {
        self.performSegueWithIdentifier("success", sender: self)
    }
    func onFailure() {
        self.displayAlertWithTitleForError("", message: "Please provide proper username and password combination")
    }
    func displayAlertWithTitleForError(title:String, message:String) {
        let uiAlertController:UIAlertController = UIAlertController(title: title,
                                                                    message: message, preferredStyle: UIAlertControllerStyle.Alert)
        uiAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel,
            handler:{(action:UIAlertAction)->Void in }))
        if presentedViewController == nil {
            self.presentViewController(uiAlertController, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        self.navigationItem.setHidesBackButton(true, animated:true)
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "hotel-dining.jpg")!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.activityIndicatorView.stopAnimating()
        // Calling retrive method to handle the data delay during fetch from database
        ParseOperations.retrieveBreakFastMenu()
        ParseOperations.retrieveLunchMenu()
        ParseOperations.retrieveDinnerMenu()
        ParseOperations.retrieveLateNightMenu()
    }
    
}
