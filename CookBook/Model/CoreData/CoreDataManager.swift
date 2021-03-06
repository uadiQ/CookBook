//
//  CoreDataManager.swift
//  CookBook
//
//  Created by Vadim Shoshin on 25.02.2018.
//  Copyright © 2018 Vadim Shoshin. All rights reserved.
//

import UIKit
import CoreData

final class CoreDataManager {
    static let instance = CoreDataManager()
    private init() {}
    
    var isFavoritesEmpty: Bool {
        let request: NSFetchRequest = MealMO.fetchRequest()
        guard let categoriesCount = try? persistentContainer.viewContext.count(for: request) else { return false }
        return !(categoriesCount > 0)
    }
    
    func fetchFavorites(completionHandler: @escaping ([Meal]) -> Void) {
        persistentContainer.performBackgroundTask { bgContext in
            let request: NSFetchRequest = MealMO.fetchRequest()
            let fetchedResult = (try? bgContext.fetch(request)) ?? []
            let result = fetchedResult.map {
                $0.convertedPlainObject()
            }
            completionHandler(result)
        }
    }
    
    func addMealToFavorites(_ meal: Meal) {
        persistentContainer.performBackgroundTask { bgContext in
            let mealMO = MealMO(context: bgContext)
            mealMO.setup(from: meal)
            try? bgContext.save()
        }
    }
    
    func refreshFavorites(_ favorites: [Meal]) {
        deleteAllData()
        persistentContainer.performBackgroundTask { bgContext in
            favorites.forEach {
                let mealMO = MealMO(context: bgContext)
                mealMO.setup(from: $0)
            }
            try? bgContext.save()
        }
    }
    
    func deleteAllData() {
        persistentContainer.performBackgroundTask { bgContext in
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: MealMO.fetchRequest())
            _ = try? bgContext.execute(deleteRequest)
            try? bgContext.save()
        }
    }
    
    func deleteMealFromFavorites(_ meal: Meal) {
        guard let deletionId = meal.id else { return }
        persistentContainer.performBackgroundTask { bgContext in
            let request: NSFetchRequest<MealMO> = MealMO.fetchRequest()
//            let secondPredicate = NSPredicate(format: "title LIKE %@", meal.title)
       //  let titlePredicate = NSPredicate(format: "title contains[cd] '\(meal.title)'")
            let idPredicate = NSPredicate(format: "id = %d", deletionId)
            request.predicate = idPredicate
            if let result = try? bgContext.fetch(request) {
                for object in result {
                    bgContext.delete(object)
                }
            }
            try? bgContext.save()
        }
    }
    
    // MARK: - Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "CookBook")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
        private func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
