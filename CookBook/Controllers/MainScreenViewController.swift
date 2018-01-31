//
//  MainScreenViewController.swift
//  CookBook
//
//  Created by Vadim Shoshin on 30.01.2018.
//  Copyright © 2018 Vadim Shoshin. All rights reserved.
//

import UIKit
import PKHUD

class MainScreenViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        addObservers()
        searchBar.delegate = self
        tableView.keyboardDismissMode = .onDrag
        HUD.show(.progress, onView: view)
        DataManager.instance.loadDefaultReceiptFromNet()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(mealsLoaded), name: .MealsLoaded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(emptySearchResult), name: .EmptySearchResult, object: nil)
    }
    
    private func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func showErrorAlertWithOk(title: String, message: String) {
        let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        errorAlert.addAction(okAction)
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// MARK: - TableView Delegate & DataSource

extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.instance.meals.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mealTableViewCell", for: indexPath) as? MealTableViewCell else { fatalError("Cell with wrong ID") }
        guard let mealToPresent = DataManager.instance.getMeal(at: indexPath) else { fatalError("Meal @ wrong indexPath") }

        let imageToSet = mealToPresent.image ?? #imageLiteral(resourceName: "placeholder")
        cell.update(title: mealToPresent.title, ingredients: mealToPresent.ingredients, image: imageToSet)
        return cell
    }
}

// MARK: - UISearchBar Delegate

extension MainScreenViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        HUD.show(.progress, onView: view)
        hideKeyboard()
        guard let mealToSearch = searchBar.text else {
            showErrorAlertWithOk(title: "Error", message: "Enter meal to search for")
            return
        }
        DataManager.instance.searchReceipts(for: mealToSearch)
    }
}

// MARK: - Notifications Extension

extension MainScreenViewController {
    @objc func mealsLoaded() {
        HUD.hide()
        tableView.reloadData()
    }
    
    @objc func emptySearchResult() {
        HUD.hide()
        showErrorAlertWithOk(title: "No Result", message: "No results for your request, try something else!")
    }
}
