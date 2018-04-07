//
//  MealMO+CoreDataClass.swift
//  CookBook
//
//  Created by Vadim Shoshin on 25.02.2018.
//  Copyright © 2018 Vadim Shoshin. All rights reserved.
//
//

import UIKit
import CoreData

public class MealMO: NSManagedObject {
    func convertedPlainObject() -> Meal {
        guard let stringedReceipt = self.receiptURL else { fatalError("cannot obtain url from MO")}
        var plainMealObject = Meal(title: self.title ?? "",
                    ingredients: self.ingredients ?? "",
                    thumbnailUrl: URL(string: self.thumbnailUrl ?? ""),
                    receiptURL: URL(string: stringedReceipt))
        plainMealObject.addImage(from: self.image)
        plainMealObject.id = Int(self.id)
        return plainMealObject
    }
    
    func setup(from meal: Meal) {
        self.title = meal.title
        self.ingredients = meal.ingredients
        self.thumbnailUrl = String(describing: meal.thumbnailUrl)
        guard let receiptUrl = meal.receiptURL else { print("Failed at getting receiptUrl"); return }
        self.receiptURL = String(describing: receiptUrl)
        self.id = Int32(meal.id ?? 0)
        if let image = meal.image {
            guard let imageData = UIImagePNGRepresentation(image) else { return }
            self.image = NSData(data: imageData)
        }
    }
}
