//
//  FavMealsViewController.swift
//  CookBook
//
//  Created by Vadim Shoshin on 11.02.2018.
//  Copyright © 2018 Vadim Shoshin. All rights reserved.
//

import UIKit

class FavMealsViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    private var isSearchEnabled: Bool = false
    private var searchResultArray: [Meal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.instance.loadFavorites()
        //CoreDataManager.instance.deleteAllData()
        addObservers()
        tableView.register(MealViewCell.nib, forCellReuseIdentifier: MealViewCell.reuseID)
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.keyboardDismissMode = .onDrag
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destVC = segue.destination as? MealDetailsViewController else { return }
        destVC.meal = sender as? Meal
        destVC.isFromFavoritesScreen = true
    }
    
    // MARK: - Private methods
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(favMemesArrayChanged), name: .MealAddedToFavorites, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(favMemesArrayChanged), name: .FavoriteMealsFetched, object: nil)
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
        return isSearchEnabled ? searchResultArray[indexPath.row] : DataManager.instance.favoriteMeals[indexPath.row]
    }
    
    private func findMeals(for mealName: String) {
        isSearchEnabled = !mealName.isEmpty
        searchResultArray.removeAll()
        for meal in DataManager.instance.favoriteMeals where meal.title.lowercased().contains(mealName.lowercased()) {
            searchResultArray.append(meal)
        }
        tableView.reloadData()
    }
    
}

// MARK: - TableView

extension FavMealsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MealViewCell.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchEnabled ? searchResultArray.count : DataManager.instance.favoriteMeals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MealViewCell.reuseID, for: indexPath) as? MealViewCell else {
            fatalError("Cell with wrong ID")
        }
        
        guard let mealToPresent = getMeal(at: indexPath) else { fatalError("Meal @ wrong indexPath") }
        //cell.update(title: mealToPresent.title, ingredients: mealToPresent.ingredients, imageURL: mealToPresent.thumbnailUrl)
        cell.updateWithFavMeal(title: mealToPresent.title, ingredients: mealToPresent.ingredients, image: mealToPresent.image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let meal = getMeal(at: indexPath) else { return }
        performSegue(withIdentifier: "showFavMealDetails", sender: meal)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else { return }
        guard let item = getMeal(at: indexPath) else { fatalError("Error @ getting meals for table") }
        DataManager.instance.deleteMealFromFavorites(item)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}

// MARK: - SeachBar

extension FavMealsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hideKeyboard()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        findMeals(for: searchText)
    }
}

// MARK: - Notifications

extension FavMealsViewController {
    @objc func favMemesArrayChanged() {
        tableView.reloadData()
    }
}
