//
//  MealTableViewCell.swift
//  CookBook
//
//  Created by Vadim Shoshin on 30.01.2018.
//  Copyright © 2018 Vadim Shoshin. All rights reserved.
//

import UIKit
import AlamofireImage

class MealTableViewCell: UITableViewCell {
    @IBOutlet private weak var ibImageView: UIImageView!
    @IBOutlet private weak var ibTitleLabel: UILabel!
    @IBOutlet private weak var ibIngredientsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        ibImageView.layer.cornerRadius = ibImageView.frame.width / 2.0
    }
    
    func update(title: String, ingredients: String, imageURL: URL?) {
        if let url = imageURL {
        ibImageView.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "placeholder"))
        } else {
            ibImageView.image = #imageLiteral(resourceName: "placeholder")
        }
        ibTitleLabel.text = title
        ibIngredientsLabel.text = ingredients
    }
    
}
