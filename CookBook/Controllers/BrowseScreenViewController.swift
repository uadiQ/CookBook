//
//  BrowseScreenViewController.swift
//  CookBook
//
//  Created by Vadim Shoshin on 11.02.2018.
//  Copyright © 2018 Vadim Shoshin. All rights reserved.
//

import UIKit
import PKHUD

class BrowseScreenViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MealViewCell.nib, forCellReuseIdentifier: MealViewCell.reuseID)
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.keyboardDismissMode = .onDrag
        addObservers()
        HUD.show(.progress, onView: view)
        DataManager.instance.loadDefaultReceiptFromNet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
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
    
    private func getMeal(at indexPath: IndexPath) -> Meal? {
        guard !DataManager.instance.meals.isEmpty else { return nil }
        return DataManager.instance.meals[indexPath.row]
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destVC = segue.destination as? MealDetailsViewController else { return }
        destVC.meal = sender as? Meal
        destVC.isFromFavoritesScreen = false
    }
    
}

// MARK: - TableView Delegate & DataSource

extension BrowseScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.instance.meals.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MealViewCell.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MealViewCell.reuseID, for: indexPath) as? MealViewCell else {
            fatalError("Cell with wrong ID")
        }
        
        guard let mealToPresent = getMeal(at: indexPath) else { fatalError("Meal @ wrong indexPath") }
        
        cell.update(title: mealToPresent.title, ingredients: mealToPresent.ingredients, imageURL: mealToPresent.thumbnailUrl)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let meal = getMeal(at: indexPath) else { return }
        performSegue(withIdentifier: "showMealDetails", sender: meal)
    }
}

// MARK: - UISearchBar Delegate

extension BrowseScreenViewController: UISearchBarDelegate {
    
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

extension BrowseScreenViewController {
    @objc func mealsLoaded() {
        HUD.hide()
        tableView.reloadData()
    }
    
    @objc func emptySearchResult() {
        HUD.hide()
        tableView.reloadData()
        showErrorAlertWithOk(title: "No Result", message: "No results for your request, try something else!")
        
    }
}
