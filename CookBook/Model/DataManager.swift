//
//  DataManager.swift
//  CookBook
//
//  Created by Vadim Shoshin on 30.01.2018.
//  Copyright © 2018 Vadim Shoshin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PKHUD

final class DataManager {
    static let instance = DataManager()
    private init() { }
    
    private(set) var meals: [Meal] = []
    private(set) var favoriteMeals: [Meal] = []
    
    func loadDefaultReceiptFromNet() {
        Alamofire.request(Endpoint.basicUrl + "pasta").responseJSON { response in
            switch response.result {
            case .success(let value):
                let jsonResponse = JSON(value)
                guard let mealsJSONArray = jsonResponse["results"].array else {
                    print("Response didn't turn into array")
                    return
                }
                
                if mealsJSONArray.isEmpty {
                    NotificationCenter.default.post(name: .EmptySearchResult, object: nil)
                    return
                }
                for item in mealsJSONArray {
                    guard let meal = Meal(json: item) else { debugPrint("Error @ creating meal from json"); continue }
                    self.meals.append(meal)
                }
                NotificationCenter.default.post(name: .MealsLoaded, object: nil)
                
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func searchReceipts(for meal: String) {
        Alamofire.request(Endpoint.basicUrl + meal).responseJSON { response in
            switch response.result {
            case .success(let value):
                let jsonResponse = JSON(value)
                guard let mealsJSONArray = jsonResponse["results"].array else {
                    debugPrint("Response didn't turn into array")
                    return
                }
                
                if mealsJSONArray.isEmpty {
                    self.meals = []
                    NotificationCenter.default.post(name: .EmptySearchResult, object: nil)
                    return
                }
                self.meals.removeAll()
                for item in mealsJSONArray {
                    guard let meal = Meal(json: item) else { debugPrint("Error @ creating meal from json"); continue }
                    self.meals.append(meal)
                }
                NotificationCenter.default.post(name: .MealsLoaded, object: nil)
                
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func addToFavorites(meal: Meal) {
        guard !favoriteMeals.contains(meal) else { return }
        favoriteMeals.append(meal)
        NotificationCenter.default.post(name: .MealAddedToFavorites, object: nil)
    }
    
    func deleteMealFromFavorites(_ meal: Meal) {
        guard let deletingIndex = favoriteMeals.index(of: meal) else { debugPrint("Can't delete nonexisting meal"); return }
        favoriteMeals.remove(at: deletingIndex)
    }
    
}
