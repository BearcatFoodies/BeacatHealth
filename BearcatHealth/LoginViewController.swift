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
class LoginViewController: UIViewController{
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
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
    }
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBAction func login(sender: UIButton) {
        self.activityIndicatorView.startAnimating()
        appDelegate.userName = userName.text!
        PFUser.logInWithUsernameInBackground(userName.text!, password: password.text!, block : {(user,error)-> Void in
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
        displayAlertWithTitle("Success", message:"Login Successful")
    }
    func onFailure() {
        self.displayAlertWithTitleForError("", message: "Please provide proper username and password combination")
    }
    func displayAlertWithTitle(title:String, message:String) {
        let uiAlertController:UIAlertController = UIAlertController(title: title,
                                                                    message: message, preferredStyle: UIAlertControllerStyle.Alert)
        uiAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel,
            handler:  { action in self.performSegueWithIdentifier("success", sender: self) }))
        if presentedViewController == nil {
            self.presentViewController(uiAlertController, animated: true, completion: nil)
        }
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
}
