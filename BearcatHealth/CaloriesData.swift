//
//  caloriesData.swift
//  BearcatHealth
//
//  Created by Pachipulusu,Venkatakotianilkumar on 11/16/16.
//  Copyright © 2016 Gayam,Prathibha. All rights reserved.
//

import Foundation
import Parse
import Bolts
// Model class for Calories table
class CaloriesData:PFObject , PFSubclassing {
    @NSManaged var itemName: String
    @NSManaged var dayServed: String
    @NSManaged var location: String
    @NSManaged var mealType: String
    @NSManaged var calories: Int
    @NSManaged var sid: String
    static func parseClassName() -> String {
        return "CaloriesData"
    }
}