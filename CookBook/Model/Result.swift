//
//  Result.swift
//  CookBook
//
//  Created by Vadim Shoshin on 04.06.2018.
//  Copyright © 2018 Vadim Shoshin. All rights reserved.
//

import UIKit
import SwiftyJSON

enum Result<Value> {
    case success(Value)
    case fail(Error)
}
