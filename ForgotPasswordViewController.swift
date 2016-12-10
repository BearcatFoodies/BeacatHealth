//
//  ForgotPasswordViewController.swift
//  BearcatHealth
//
//  Created by Tarugu,Prudhvi Krishna Subbaiah on 12/4/16.
//  Copyright © 2016 Gayam,Prathibha. All rights reserved.
//
import UIKit
import Parse
import Bolts

// It allows the user to reset their password incase if the user forgets his password. It sends an email to the registered email address to reset the password.
class ForgotPasswordViewController: UIViewController {
    // MARK: - Properties
    // An outlet for email id text field
    @IBOutlet weak var emailIdTF: UITextField!
    // Below method dismiss the view controller
    
    // MARK: - Default methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "hotel-dining.jpg")!)
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - reset password
    // Function that allows the user to reset his/her password by sending a email to the registered email address
    @IBAction func resetPwdBTN(sender: AnyObject) {
        if emailIdTF.text!.isEmpty{
            emailIdTF.layer.borderWidth = 1
            emailIdTF.layer.borderColor = UIColor.redColor().CGColor
            displayMyAlertMessage("Please provide valid email")
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
                displayMyAlertMessage("Please provide valid email")
            }
        }
        let emailId = emailIdTF!.text
        //Check for empty field
        if emailId!.isEmpty {
            displayMyAlertMessage("Please enter your registered EmailId")
        }
        let email = emailId!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        PFUser.requestPasswordResetForEmailInBackground(email)
        let alert = UIAlertController (title: "Password Reset", message: "An email has been sent to" + email + "to reset your password", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    @IBAction func closeFgtPwdBTN(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    // MARK: - Alert
    // Function to display the error message
    func displayMyAlertMessage(userMessage:String) {
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
}
