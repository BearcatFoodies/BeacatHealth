//
//  Profile.swift
//  BearcatHealth
//
//  Created by Gayam,Prathibha on 10/25/16.
//  Copyright © 2016 Gayam,Prathibha. All rights reserved.
//

import Foundation
import Parse
import Bolts
// A simple part of the model
class Profile:PFObject , PFSubclassing{
    @NSManaged var sid: String
    @NSManaged var height: String
    @NSManaged var weight: String
    @NSManaged var gender: String
    @NSManaged var activity:String
    @NSManaged var age: Int
    static func parseClassName() -> String {
        return "Profile"
    }
}