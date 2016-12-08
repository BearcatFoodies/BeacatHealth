//
//  AccountViewController.swift
//  BearcatHealth
//  Created by Gayam,Prathibha on 10/6/16.
//  Copyright © 2016 Gayam,Prathibha. All rights reserved.
//
import UIKit
import Parse
import Bolts
//This view controller gets the data from profile view and stores them in profile table
class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var heightPV: UIPickerView!
    @IBOutlet weak var weightPV: UIPickerView!
    @IBOutlet weak var genderPV: UIPickerView!
    @IBOutlet weak var activityPV: UIPickerView!
    @IBOutlet weak var profilePhotoIV: UIImageView!
    let  profile =  Profile()
    @IBOutlet weak var agePV: UIPickerView!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var genderArray:[String] = ["Male", "Female"]
    var heightArray:[Int] = []
    var weightArray:[Int] = []
    var activityArray:[String] = ["Light Activity", "Moderate Activity", "Heavy Activity"]
    var ageArray:[Int] = []
    override func viewWillAppear(animated: Bool) {
        activityIndicator.hidden = true
        name.text = "Hello, " + appDelegate.userName
        if MenuViewController.userscount > 0 {
            self.activityTF.text = appDelegate.user.activity
            self.ageTF.text = String(appDelegate.user.age)
            self.heightTF.text = appDelegate.user.height
            self.weightTF.text = appDelegate.user.weight
            self.genderTF.text = appDelegate.user.gender
        }
    }
    @IBAction func uploadPhotoBTN(sender: AnyObject) {
        let imagePC = UIImagePickerController()
        imagePC.delegate=self
        imagePC.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePC, animated: true, completion: nil)
    }
    // this field gets the bearcatID entered by the user
    @IBOutlet weak var sidTF: UITextField!
    // this field gets the height entered by the user
    @IBOutlet weak var heightTF: UITextField!
    // this field gets the weight entered by the user
    @IBOutlet weak var weightTF: UITextField!
    // this field gets the gender entered by the user
    @IBOutlet weak var genderTF: UITextField!
    // this field gets the age entered by the user
    @IBOutlet weak var ageTF: UITextField!
    // this field gets the activity entered by the user
    @IBOutlet weak var activityTF: UITextField!
    // This method stores the data which was retrived from the profile view.
    @IBAction func saveDataBtn(sender: AnyObject) {
        if heightTF.text!.isEmpty || weightTF.text!.isEmpty || genderTF.text!.isEmpty  || ageTF.text!.isEmpty || activityTF.text!.isEmpty {
            self.displayAlertWithTitle("", message:"Please provide All the details")
            return
        }
        self.activityIndicator.hidden = false
        if Int(ageTF.text!) == nil {
            displayAlertWithTitle("", message: "Age is invalid")
            return
        }
        if Double(heightTF.text!) == nil  {
            displayAlertWithTitle("", message: "Height is invalid")
            return
        }
        if Double(weightTF.text!) == nil  {
            displayAlertWithTitle("", message: "Height is invalid")
            return
        }
        if activityTF.text == nil  {
            displayAlertWithTitle("", message: "Activity is invalid")
            return
        }
        profile.sid = appDelegate.userName
        if !heightTF.text!.isEmpty {
            profile.height = heightTF.text! }
        else {
            self.displayAlertWithTitle("", message:"Please provide Height")
        }
        if !weightTF.text!.isEmpty {
            profile.weight = weightTF.text! }
        else {
            self.displayAlertWithTitle("", message:"Please provide Weight")
        }
        if !genderTF.text!.isEmpty {
            profile.gender = genderTF.text! }
        else {
        }
        if !ageTF.text!.isEmpty {
            profile.age = Int(ageTF.text!)! }
        else{
            self.displayAlertWithTitle("", message:"Please provide Age")
        }
        if !activityTF.text!.isEmpty {
            profile.activity = activityTF.text! }
        else {
            self.displayAlertWithTitle("", message:"Please provide Activity")
        }
        self.activityIndicator.startAnimating()
        profile.saveInBackgroundWithBlock({ (success, error) -> Void in
            if success {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
                self.displayAlertWithTitle("Success!", message:"Profile has been saved")
                self.calorieIntake()
            }
            else {
                self.displayAlertWithTitle("Oops!", message:"Please try again with valid inputs")
                self.activityIndicator.stopAnimating()
            }
        })
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        profilePhotoIV.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(true , completion: nil)
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var numRows : Int = 0
        if pickerView == heightPV {
            numRows = heightArray.count
        }
        if pickerView == weightPV{
            numRows = weightArray.count
        }
        if pickerView == genderPV{
            numRows = genderArray.count
        }
        if pickerView == activityPV{
            numRows = activityArray.count
        }
        if pickerView == agePV{
            numRows = ageArray.count
        }
        return numRows
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var rowTitle:String = ""
        if pickerView == heightPV {
            rowTitle = String(heightArray[row])
            return rowTitle
        }
        else if pickerView == weightPV{
            rowTitle = String(weightArray[row])
            return rowTitle
        }
        else if pickerView == genderPV{
            rowTitle = genderArray[row]
            return rowTitle
        }
        if pickerView == activityPV{
            rowTitle = activityArray[row]
            return  rowTitle
        }
        if pickerView == agePV{
            rowTitle = String(ageArray[row])
            return  rowTitle
        }
        return ""
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == heightPV{
            heightTF.text = String(heightArray[row])
            self.heightPV.hidden = true
        }
        if pickerView == weightPV {
            weightTF.text = String(weightArray[row])
            self.weightPV.hidden = true
        }
        if pickerView == genderPV {
            self.genderTF.text = self.genderArray[row]
            self.genderPV.hidden = true
        }
        if pickerView == activityPV {
            self.activityTF.text = self.activityArray[row]
            self.activityPV.hidden = true
        }
        if pickerView == agePV {
            self.ageTF.text = String(ageArray[row])
            self.agePV.hidden = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "hotel-dining.jpg")!)
        self.heightPV.hidden = true
        self.weightPV.hidden = true
        self.genderPV.hidden = true
        self.activityPV.hidden = true
        self.agePV.hidden = true
        for data in 55...1000 {
            weightArray.append(data)
        }
        for data in 55...215 {
            heightArray.append(data)
        }
        for data in 10...100{
            ageArray.append(data)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func textFieldShouldBeginEditing(textField: UITextField)  {
        if textField  == self.weightTF {
            self.weightPV.hidden = false
        }
        if textField == self.heightTF {
            self.heightPV.hidden = false
        }
        if textField == self.genderTF {
            self.genderPV.hidden = false
        }
        if textField == self.activityTF {
            self.activityPV.hidden = false
        }
        if textField == self.ageTF {
            self.agePV.hidden = false
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    @IBAction func disablePickeViews(tapGR:UITapGestureRecognizer) -> Void{
        weightPV.hidden=true
        heightPV.hidden = true
        genderPV.hidden = true
        activityPV.hidden = true
        agePV.hidden = true
    }
    func displayAlertWithTitle(title:String, message:String){
        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction:UIAlertAction =  UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    func calorieIntake() {
        var calories = 0.0
        let weight: Double = Double(weightTF.text!)!
        let height: Double = Double(heightTF.text!)!
        let age: Double = Double(ageTF.text!)!
        if genderTF.text == "Male" {
            if activityTF.text == "Light Activity" {
                calories = (10*weight + 6.25*height - 5*age + 5) * 1.375
            }else if activityTF.text == "Moderate Activity" {
                calories = (10*weight + 6.25*height - 5*age + 5) * 1.55
            } else if activityTF.text == "Heavy Activity"{
                calories = (10*weight + 6.25*height - 5*age + 5) * 1.95
            }
        } else if genderTF.text == "Female" {
            if activityTF.text == "Light Activity" {
                calories = (10*weight + 6.25*height - 5*age - 161) * 1.375
            }else if activityTF.text == "Moderate Activity" {
                calories = (10*weight + 6.25*height - 5*age - 161) * 1.55
            } else if activityTF.text == "Heavy Activity"{
                calories = (10*weight + 6.25*height - 5*age - 161) * 1.95
            }
        }
        appDelegate.calorie = calories
    }
}