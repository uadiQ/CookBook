//
//  NetworkManager.swift
//  CookBook
//
//  Created by Vadim Shoshin on 04.06.2018.
//  Copyright © 2018 Vadim Shoshin. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

enum NetworkError: Error {
    case urlCreation
    case noData
}

final class NetworkManager {
    
    func searchRequest(for meal: String, completionHanlder: @escaping (Result<Any>) -> Void) {
        guard let requestUrl = URL(string: (Endpoint.basicUrl + meal)) else {
            print("Error @ creating url")
            completionHanlder(.fail(NetworkError.urlCreation))
            return
        }
        Alamofire.request(requestUrl).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("ok")
                let jsonResponse = JSON(value)
                guard let mealsJSONArray = jsonResponse["results"].array else {
                    print("Response didn't turn into array")
                    completionHanlder(.fail(NetworkError.noData))
                    return
                }
                completionHanlder(.success(mealsJSONArray))
                
            case .failure(let error):
                print("error - \(error)")
                
            }
        }
    }
}
