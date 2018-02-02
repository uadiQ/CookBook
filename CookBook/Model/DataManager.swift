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
    
    var meals: [Meal] = []
    
    func loadDefaultReceiptFromNet() {
        Alamofire.request(Utils.basicUrl + "pasta").responseJSON { response in
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
                    guard let meal = Meal(json: item) else { print("Error @ creating meal from json"); continue }
                    self.meals.append(meal)
                }
                NotificationCenter.default.post(name: .MealsLoaded, object: nil)
                
            case .failure(let error):
                print("Loading from net failed: \(error)")
            }
        }
    }
    
    func searchReceipts(for meal: String) {
        Alamofire.request(Utils.basicUrl + meal).responseJSON { response in
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
                self.meals.removeAll()
                for item in mealsJSONArray {
                    guard let meal = Meal(json: item) else { print("Error @ creating meal from json"); continue }
                    self.meals.append(meal)
                }
                NotificationCenter.default.post(name: .MealsLoaded, object: nil)
                
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
