//
//  MealDetailsViewController.swift
//  CookBook
//
//  Created by Vadim Shoshin on 01.02.2018.
//  Copyright © 2018 Vadim Shoshin. All rights reserved.
//

import UIKit

class MealDetailsViewController: UIViewController {
    @IBOutlet private weak var ibImageView: UIImageView!
    @IBOutlet private weak var ibTitleText: UILabel!
    @IBOutlet private weak var ibReceiptText: UITextView!
    
    var meal: Meal!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = meal.title
        ibImageView.image = meal.image ?? #imageLiteral(resourceName: "placeholder")
        ibTitleText.text = meal.title
        ibReceiptText.text = meal.ingredients
    }
    
    @IBAction func showReceiptPushed(_ sender: Any) {
        guard let urlToLoad = meal.receiptURL else { return }
        UIApplication.shared.open(urlToLoad, options: [:], completionHandler: nil)
    }
}
