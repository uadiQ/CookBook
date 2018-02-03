//
//  Meal.swift
//  CookBook
//
//  Created by Vadim Shoshin on 30.01.2018.
//  Copyright © 2018 Vadim Shoshin. All rights reserved.
//

import UIKit
import SwiftyJSON
import AlamofireImage

struct Meal: Equatable {

    let title: String
    let ingredients: String
    let thumbnailUrl: URL?
    let receiptURL: URL?
    
    // var image: UIImage?
    
    init?(json: JSON) {
        guard let title = json["title"].string else { print("error @ getting title"); return nil }
        self.title = title
        self.ingredients = json["ingredients"].stringValue
        self.thumbnailUrl = json["thumbnail"].url
        self.receiptURL = json["href"].url
        
//        if let urlToDownload = self.thumbnailUrl {
//            guard let dataImage = try? Data(contentsOf: urlToDownload) else { return }
//            self.image = UIImage(data: dataImage)
//        }
        
    }
}

extension Meal {
    static func == (lhs: Meal, rhs: Meal) -> Bool {
        return lhs.title == rhs.title
    }
}
