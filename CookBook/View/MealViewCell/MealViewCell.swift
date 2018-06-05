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
    
    //static let height: CGFloat = 100
    
    @IBOutlet private weak var ibImageView: UIImageView!
    @IBOutlet private weak var ibTitleLabel: UILabel!
    @IBOutlet private weak var ibIngredientsLabel: UILabel!
    
    enum LabelsSpacing {
        static let rightSpacing: CGFloat = 15.0
        static let leftSpacing: CGFloat = 15.0
        static let titleTopSpacing: CGFloat = 15.0
        static let ingredientsTopSpacing: CGFloat = 15.0
        static let ingredientsBottomSpacing: CGFloat = 15.0
    }
    
    enum ImageSpacings {
        static let topSpacing: CGFloat = 15.0
        static let bottomSpacing: CGFloat = 15.0
        static let leftSpacing: CGFloat = 15.0
    }
    
    enum Fonts {
        static let titleFont: UIFont = .systemFont(ofSize: 15)
        static let ingredientsFont: UIFont = .systemFont(ofSize: 15)
    }
    
    static func height(for meal: Meal, tableViewWidth: CGFloat) -> CGFloat {
        let height: CGFloat
        let labelAllowedWidth = tableViewWidth - ImageSpacings.leftSpacing - LabelsSpacing.leftSpacing - LabelsSpacing.rightSpacing
        
        let titleHeight = meal.title.heightWithConstrainedWidth(labelAllowedWidth, font: Fonts.titleFont)
        let ingredientsHeight = meal.ingredients.heightWithConstrainedWidth(labelAllowedWidth, font: Fonts.ingredientsFont)
        
        let labelsHeight = titleHeight + ingredientsHeight + LabelsSpacing.titleTopSpacing + LabelsSpacing.ingredientsTopSpacing + LabelsSpacing.ingredientsBottomSpacing
        let imageHeight = 90 + ImageSpacings.topSpacing + ImageSpacings.bottomSpacing
        
        if labelsHeight >= imageHeight {
            height = labelsHeight
        } else {
            height = imageHeight
        }
        
        return height
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupFonts()
        selectionStyle = .none
        let cellSize = self.frame.height
        let imageSize = cellSize - 30.0
        ibImageView.layer.cornerRadius = imageSize / 2.0
        //        ibImageView.layer.cornerRadius = ibImageView.frame.height / 2.0
    }
    
    private func setupFonts() {
        ibTitleLabel.font = MealViewCell.Fonts.titleFont
        ibIngredientsLabel.font = MealViewCell.Fonts.ingredientsFont
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
    
    func updateWithFavMeal(title: String, ingredients: String, image: UIImage?) {
        ibImageView.image = image ?? #imageLiteral(resourceName: "placeholder")
        ibTitleLabel.text = title
        ibIngredientsLabel.text = ingredients
    }
    
}
