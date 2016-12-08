//
//  Breakfast.swift
//  BearcatHealth
//
//  Created by Pachipulusu,Venkatakotianilkumar on 11/1/16.
//  Copyright © 2016 Gayam,Prathibha. All rights reserved.
//

import Foundation
import Parse
import Bolts
// A simple part of the model
class FoodData:PFObject , PFSubclassing{
    @NSManaged var itemName: String
    @NSManaged var dayServed: String
    @NSManaged var location: String
    @NSManaged var mealType: String
    @NSManaged var calories: Int
    static func parseClassName() -> String {
        return "FoodData"
    }
}