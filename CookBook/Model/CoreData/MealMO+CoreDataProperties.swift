//
//  MealMO+CoreDataProperties.swift
//  CookBook
//
//  Created by Vadim Shoshin on 25.02.2018.
//  Copyright © 2018 Vadim Shoshin. All rights reserved.
//
//

import Foundation
import CoreData

extension MealMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MealMO> {
        return NSFetchRequest<MealMO>(entityName: "MealMO")
    }

    @NSManaged public var title: String?
    @NSManaged public var ingredients: String?
    @NSManaged public var thumbnailUrl: String?
    @NSManaged public var image: NSData?
    @NSManaged public var receiptURL: String?

}
