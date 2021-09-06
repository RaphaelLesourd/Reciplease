//
//  ViewController.swift
//  Reciplease
//
//  Created by Birkyboy on 04/09/2021.
//

import Foundation
import UIKit

class SearchViewController: UIViewController, ErrorDelegate {

    // MARK: - Properties
    private let searchView = SearchView()
    private let ingredientDataSource = IngredientDataSource()

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
    }

    // MARK: - Setup
    private func setDelegates() {
        ingredientDataSource.errorDelegate = self
        searchView.addIngredientView.textField.delegate = self
        searchView.tableView.delegate = self
        searchView.tableView.dataSource = self
    }

    private func configureButtonTargets() {
        searchView.searchButton.addTarget(self,
                                          action: #selector(navigateToRecipeList),
                                          for: .touchUpInside)
        searchView.addIngredientView.addIngredientButton.addTarget(self,
                                                                   action: #selector(addIngredientToList),
                                                                   for: .touchUpInside)
    }

    // MARK: - Target
    @objc private func navigateToRecipeList() {
        let recipeListVC = RecipeTableViewController(recipeListType: .search)
        navigationController?.pushViewController(recipeListVC, animated: true)
    }

    @objc private func addIngredientToList() {
        if let ingredient = searchView.addIngredientView.textField.text {
            ingredientDataSource.addIngredient(for: ingredient)
            searchView.addIngredientView.textField.text = nil
            searchView.tableView.reloadData()
        }
    }

    @objc private func clearIngredients() {
        let alert = presentUserQueryAlert(title: "Clearing the ingredient list.",
                                          message: "Are you sure you want to clear the entire list?",
                                          okBtnTitle: "Yes",
                                          style: .destructive) { [weak self] in
            guard let self = self else {return}
            self.ingredientDataSource.clearIngredientList()
            self.searchView.tableView.reloadData()
        }
        present(alert, animated: true, completion: nil)
    }
}
// MARK: - TableView datasource
extension SearchViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchView.emptyStateView.isHidden = !ingredientDataSource.ingredients.isEmpty
        return ingredientDataSource.ingredients.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.backgroundColor = .quaternarySystemFill
        cell.textLabel?.text = ingredientDataSource.ingredients[indexPath.row]
        return cell
    }
}

// MARK: - TableView Delegate
extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.reuseIdentifier)
                as? SectionHeaderView
        else {
            return nil
        }
        view.deleteAllIngredientsButton.addTarget(self, action: #selector(clearIngredients), for: .touchUpInside)
        return ingredientDataSource.ingredients.isEmpty ? nil : view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ingredientDataSource.deleteIngredient(with: ingredientDataSource.ingredients[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - Textfield delegate
extension SearchViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addIngredientToList()
        return true
    }
}
