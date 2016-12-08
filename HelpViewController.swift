//
//  HelpViewController.swift
//  BearcatHealth
//
//  Created by Prathibha, Gayam on 12/2/16.
//  Copyright © 2016 Gayam,Prathibha. All rights reserved.
//

import UIKit
// This class HelpViewController helps us to display information about our application
class HelpViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "hotel-dining.jpg")!)
        
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Dismisses the help view controller when done button is clicked
    @IBAction func Done(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
