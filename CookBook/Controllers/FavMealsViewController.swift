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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        setupGestures()
        tableView.register(MealViewCell.nib, forCellReuseIdentifier: MealViewCell.reuseID)
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(favMemesArrayChanged), name: .MealAddedToFavorites, object: nil)
    }
    
    private func setupGestures() {
        let upSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureRecognized(_:)))
        upSwipeGesture.direction = .up
        let downSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureRecognized(_:)))
        downSwipeGesture.direction = .down
        tableView.addGestureRecognizer(upSwipeGesture)
        tableView.addGestureRecognizer(downSwipeGesture)
    }
    
    @objc private func swipeGestureRecognized(_ sender: UISwipeGestureRecognizer) {
        hideKeyboard()
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
        return DataManager.instance.favoriteMeals[indexPath.row]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destVC = segue.destination as? MealDetailsViewController else { return }
        destVC.meal = sender as? Meal
        destVC.isFromFavoritesScreen = true
    }
    
}

// MARK: - TableView

extension FavMealsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.instance.favoriteMeals.count
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
        performSegue(withIdentifier: "showFavMealDetails", sender: meal)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else { return }
        let item = DataManager.instance.favoriteMeals[indexPath.row]
        DataManager.instance.deleteMealFromFavorites(item)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}

// MARK: - SeachBar

extension FavMealsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hideKeyboard()
    }
}

// MARK: - Notifications

extension FavMealsViewController {
    @objc func favMemesArrayChanged() {
        tableView.reloadData()
    }
}
