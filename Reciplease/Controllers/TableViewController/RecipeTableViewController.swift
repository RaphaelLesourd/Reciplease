//
//  TableViewController.swift
//  Reciplease
//
//  Created by Birkyboy on 05/09/2021.
//

import UIKit

class RecipeTableViewController: UITableViewController {

    // MARK: - Properties
    private let cellIndentifier = RecipeTableViewCell.reuseIdentifier
    private var recipeListType: RecipeListType
    private let recipeListEmptyStateView = RecipeTableViewEmptyStateView()
    private let recipeDataSource = RecipeDataSource()
    private var recipes: [RecipeClass] = [] {
        didSet {
            filteredRecipes = recipes
        }
    }
    private var filteredRecipes: [RecipeClass] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    let emptyStateView = RecipeTableViewEmptyStateView()

    // MARK: - Initializers
    init(recipeListType: RecipeListType) {
        self.recipeListType = recipeListType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        addKeyboardDismissGesture()
        configureTableView()
        configureSearchController()
        setEmptyStateViewConstraints()
    }

    // MARK: - Setup
    private func configureTableView() {
        self.tableView.register(RecipeTableViewCell.self, forCellReuseIdentifier: cellIndentifier)
        self.tableView.rowHeight = 170
        self.tableView.separatorStyle = .none
    }

    private func configureSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search for recipes"
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
    }

    // MARK: - TableView Datasource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emptyStateView.isHidden = !filteredRecipes.isEmpty
        return filteredRecipes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: cellIndentifier,
            for: indexPath
        ) as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        let recipes = filteredRecipes[indexPath.row]
        cell.configure(with: recipes)
        return cell
    }

    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipeDetailVC = RecipeDetailViewController()
        navigationController?.pushViewController(recipeDetailVC, animated: true)
    }

    // ContextMenu
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration {
        let addAction = self.addToFavoriteAction(forRowAtIndexPath: indexPath)
        let removeAction = self.removeFromFavoriteAction(forRowAtIndexPath: indexPath)
        let action = recipeListType == .favorite ? removeAction : addAction
        let swipeConfig = UISwipeActionsConfiguration(actions: [action])
        return swipeConfig
    }

    private func addToFavoriteAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Add favorite") { (_, _, completion) in

            completion(true)
        }
        action.backgroundColor = .systemOrange
        action.image = UIImage(systemName: "star.fill")
        return action
    }

    private func removeFromFavoriteAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete favorite") { (_, _, completion) in
            self.recipes.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            completion(true)
        }
        action.backgroundColor = .systemRed
        action.image = UIImage(systemName: "trash.fill")
        return action
    }
}

// MARK: - Search result updater
extension RecipeTableViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {return}
        if searchText.isEmpty {
            filteredRecipes = recipes
        } else {
            filteredRecipes = recipes.filter({
                guard let recipeName = $0.label else { return false }
                return recipeName.contains(searchText)
            })
        }
    }
}
// MARK: - Constraints
extension RecipeTableViewController {

    private func setEmptyStateViewConstraints() {
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyStateView)
        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
}
