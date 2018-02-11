//
//  MealDetailsViewController.swift
//  CookBook
//
//  Created by Vadim Shoshin on 01.02.2018.
//  Copyright © 2018 Vadim Shoshin. All rights reserved.
//

import UIKit
import AlamofireImage
import SafariServices
import PKHUD

class MealDetailsViewController: UIViewController {
    @IBOutlet private weak var addToFavoritesButton: UIBarButtonItem!
    @IBOutlet private weak var ibImageView: UIImageView!
    @IBOutlet private weak var ibTitleText: UILabel!
    @IBOutlet private weak var ibReceiptText: UITextView!
    
    var isFromFavoritesScreen: Bool!
    var meal: Meal!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = meal.title
        //ibImageView.image = meal.image ?? #imageLiteral(resourceName: "placeholder")
        ibTitleText.text = meal.title
        ibReceiptText.text = meal.ingredients
        if let url = meal.thumbnailUrl {
            ibImageView.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "placeholder"))
        } else {
            ibImageView.image = #imageLiteral(resourceName: "placeholder")
        }
        addToFavoritesButton.isEnabled = !isFromFavoritesScreen
    }
    
    @IBAction func showReceiptPushed(_ sender: Any) {
        guard let urlToLoad = meal.receiptURL else { return }
        
        //UIApplication.shared.open(urlToLoad, options: [:], completionHandler: nil)
        
        let vc = SFSafariViewController(url: urlToLoad)
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func addToFavoritesPushed(_ sender: Any) {
        DataManager.instance.addToFavorites(meal: meal)
        HUD.flash(.labeledSuccess(title: "Meal added to Favorites!", subtitle: nil), delay: 1)
    }
}
