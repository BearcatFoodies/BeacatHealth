//
//  RegisterViewController.swift
//  BearcatHealth
//
//  Created by Pachipulusu,Venkatakotianilkumar on 11/14/16.
//  Copyright © 2016 Gayam,Prathibha. All rights reserved.
//

import UIKit
import Parse
import Bolts
// This class allows a new user to register
class RegisterViewController: UIViewController {
    
    // This is the outlet for firstname text field and holds firstname
    @IBOutlet weak var firstNameTF: UITextField!
  // This is the outlet for lastname text field and holds lastname
    @IBOutlet weak var lastNameTF: UITextField!
   // This is the outlet for username text field and holds username
    @IBOutlet weak var userNameTF: UITextField!
    // This is the outlet for email id text field and holds email id
    @IBOutlet weak var emailIdTF: UITextField!
    // This is the outlet for password text field and holds password
    @IBOutlet weak var passwordTF: UITextField!
    // This is the outlet for confirm password text field and holds confirm password
    @IBOutlet weak var confirmPasswordTF: UITextField!

    // This method provides the functionality for registerbutton. It validates all the inputs provided in various text fields if all inputs are propere user is registered in database
    @IBAction func registerBTN(sender: UIButton) {
        let user = PFUser()
        if firstNameTF.text!.isEmpty{
            firstNameTF.layer.borderWidth = 1
            firstNameTF.layer.borderColor = UIColor.redColor().CGColor
        }
        else
        {
            user.setObject(firstNameTF.text!, forKey: "firstName")
            firstNameTF.layer.borderColor = UIColor.whiteColor().CGColor
        }
        if lastNameTF.text!.isEmpty{
            lastNameTF.layer.borderWidth = 1
            lastNameTF.layer.borderColor = UIColor.redColor().CGColor
        }
        else
        {
            user.setObject(lastNameTF.text!, forKey: "lastName")
            lastNameTF.layer.borderColor = UIColor.whiteColor().CGColor
        }
        if userNameTF.text!.isEmpty{
            userNameTF.layer.borderWidth = 1
            userNameTF.layer.borderColor = UIColor.redColor().CGColor
        }
        else
        {
            user.username = userNameTF.text!
            userNameTF.layer.borderColor = UIColor.whiteColor().CGColor
        }
        if emailIdTF.text!.isEmpty{
            emailIdTF.layer.borderWidth = 1
            emailIdTF.layer.borderColor = UIColor.redColor().CGColor
            displayAlertControllerWithTitleforFailure("Fail!", message:"Enter Email")
        }
        else
        {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let range = emailIdTF.text!.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
            let result = range != nil ? true : false
            if result == false
            {
                emailIdTF.text = ""
                emailIdTF.layer.borderWidth = 1
                emailIdTF.layer.borderColor = UIColor.redColor().CGColor
                displayAlertControllerWithTitleforFailure("Fail!", message:"Please provide proper email")
            }
            else{
                user.email = emailIdTF.text!
                passwordTF.layer.borderColor = UIColor.whiteColor().CGColor
            }
        }
        if passwordTF.text!.isEmpty{
            passwordTF.layer.borderWidth = 1
            passwordTF.layer.borderColor = UIColor.redColor().CGColor
        }
        else
        {
            let passwordRegEx = "[A-Z0-9a-z.!@#$%^&*()]{6,13}"
            let range = passwordTF.text!.rangeOfString(passwordRegEx, options:.RegularExpressionSearch)
            let result = range != nil ? true : false
            if result == false
            {
                passwordTF.text = ""
                passwordTF.layer.borderWidth = 1
                passwordTF.layer.borderColor = UIColor.redColor().CGColor
                displayAlertControllerWithTitleforFailure("Fail!", message:"Please follow password criteria as mentioned \n")
            }
            else{
                passwordTF.layer.borderColor = UIColor.whiteColor().CGColor
            }
        }
        if passwordTF.text! != confirmPasswordTF.text!{
            displayAlertControllerWithTitleforFailure("Fail!", message:"Your passwords mismatched \n")
            passwordTF.text = ""
            confirmPasswordTF.text = ""
            passwordTF.layer.borderWidth = 1
            passwordTF.layer.borderColor = UIColor.redColor().CGColor
            confirmPasswordTF.layer.borderWidth = 1
            confirmPasswordTF.layer.borderColor = UIColor.redColor().CGColor
        }
        else{
            user.password = passwordTF.text!
        }
        // Signing up using the Parse API
        user.signUpInBackgroundWithBlock{
            (success, error) -> Void in
            if error == nil {
                self.onSuccess()
            }
            else {
                self.displayAlertControllerWithTitleforFailure("", message: "Account is already exist for the username and email combination")
            }
        }
    }
    // calls alert method if registaration is success
    func onSuccess() {
        displayAlertWithTitle("Success", message:"Registration Successful")
    }
    // Populates the alert. Presents the alert view controller for different types of alerts
    func displayAlertWithTitle(title:String, message:String) {
        let uiAlertController:UIAlertController = UIAlertController(title: title,
                                                                    message: message, preferredStyle: UIAlertControllerStyle.Alert)
        uiAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel,
            handler:  { action in self.performSegueWithIdentifier("register", sender: self) }))
        if presentedViewController ==  nil{
            self.presentViewController(uiAlertController, animated: true, completion: nil)
        }
    }
    // Populates the alert for error. Presents the alert view controller for different types of errors

    func displayAlertControllerWithTitleforFailure(title:String, message:String){
        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction:UIAlertAction =  UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        if presentedViewController ==  nil{
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    // Method for cancel button in register view controller
    @IBAction func cancelBTN(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "hotel-dining.jpg")!)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
