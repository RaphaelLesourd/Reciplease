//
//  ViewController.swift
//  Reciplease
//
//  Created by Birkyboy on 04/09/2021.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {

    // MARK: - Properties
    private let searchView = SearchView()
    private let ingredientDatasource = IngredientManager()
    private let recipeClient = RecipeService()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    // MARK: - Lifecycle
    override func loadView() {
        view = searchView
        view.backgroundColor = .secondarySystemGroupedBackground
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        addKeyboardDismissGesture()
        configureButtonTargets()
        activityIndicator.hidesWhenStopped = true
    }

    // MARK: - Setup
    private func setDelegates() {
        searchView.addIngredientView.textField.delegate = self
        searchView.tableView.delegate = self
        searchView.tableView.dataSource = self
    }

    private func configureButtonTargets() {
        searchView.searchButton.addTarget(self,
                                          action: #selector(getRecipesFromApi),
                                          for: .touchUpInside)
        searchView.addIngredientView.addIngredientButton.addTarget(self,
                                                                   action: #selector(addIngredientToList),
                                                                   for: .touchUpInside)
    }

    // MARK: - Target
    @objc private func addIngredientToList() {
        if let ingredientName = searchView.addIngredientView.textField.text {
            ingredientDatasource.addIngredient(with: ingredientName) { error in
                if let error = error {
                    return presentMessageAlert(with: error.description)
                }
                searchView.tableView.reloadData()
                searchView.addIngredientView.textField.text = nil
                dismissKeyboard()
            }
        }
    }

    @objc private func clearIngredients() {
        let alert = presentUserQueryAlert(title: "Clearing the ingredient list.",
                                          message: "Are you sure you want to clear the entire list?",
                                          okBtnTitle: "Yes",
                                          style: .destructive) { [weak self] in
            guard let self = self else {return}
            self.ingredientDatasource.clearIngredientList()
            self.searchView.tableView.reloadData()
        }
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Api Call
    @objc private func getRecipesFromApi() {
        showIndicator(activityIndicator)
        recipeClient.getRecipes(for: ingredientDatasource.ingredients) { [weak self] result in
            guard let self = self else {return}
            self.hideIndicator(self.activityIndicator)
            switch result {
            case .success(let recipeList):
                    guard let recipes = recipeList.hits, !recipes.isEmpty else {
                        self.presentMessageAlert(with: ApiError.noRecipeFound.description)
                        return
                    }
                    self.navigateToRecipeList(with: recipes)
            case .failure(let error):
                    self.presentMessageAlert(with: error.description)
            }
        }
    }

    func stopActivityIndicator() {
        hideIndicator(activityIndicator)
    }

    // MARK: - Navigation
    func navigateToRecipeList(with recipes: [Hit]) {
        let recipeListVC = RecipeTableViewController(recipeListType: .search,
                                                     recipes: recipes)
        navigationController?.pushViewController(recipeListVC, animated: true)
    }
}

// MARK: - TableView datasource
extension SearchViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchView.emptyStateView.isHidden = !ingredientDatasource.ingredients.isEmpty
        return ingredientDatasource.ingredients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.backgroundColor = .quaternarySystemFill
        cell.textLabel?.text = ingredientDatasource.ingredients[indexPath.row]
        return cell
    }
}

// MARK: - TableView Delegate
extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ingredientDatasource.deleteIngredient(with: ingredientDatasource.ingredients[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
            searchView.tableView.reloadData()
        }
    }

    // TableView header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView
                .dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.reuseIdentifier)
                as? SectionHeaderView
        else { return nil }
        view.deleteAllIngredientsButton.addTarget(self, action: #selector(clearIngredients), for: .touchUpInside)
        return ingredientDatasource.ingredients.isEmpty ? nil : view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

// MARK: - Textfield delegate
extension SearchViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addIngredientToList()
        return true
    }
}
