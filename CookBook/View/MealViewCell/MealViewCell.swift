//
//  MealViewCell.swift
//  CookBook
//
//  Created by Vadim Shoshin on 11.02.2018.
//  Copyright © 2018 Vadim Shoshin. All rights reserved.
//

import UIKit

class MealViewCell: UITableViewCell {

    static let reuseID = String(describing: MealViewCell.self)
    static let nib = UINib(nibName: String(describing: MealViewCell.self), bundle: nil)
    
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
