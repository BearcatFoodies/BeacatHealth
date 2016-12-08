//
//  temporary.swift
//  BearcatHealth
//
//  Created by admin on 11/26/16.
//  Copyright © 2016 Gayam,Prathibha. All rights reserved.
//

import Foundation
import Parse
import Bolts
class temporary:PFObject , PFSubclassing {
    @NSManaged var itemName: String
    @NSManaged var dayServed: String
    @NSManaged var location: String
    @NSManaged var mealType: String
    @NSManaged var calories: Int
    @NSManaged var sid: String
    static func parseClassName() -> String {
        return "temporary"
    }
}