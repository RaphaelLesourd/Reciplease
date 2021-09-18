//
//  TableViewController.swift
//  Reciplease
//
//  Created by Birkyboy on 05/09/2021.
//

import UIKit

class RecipeTableViewController: UITableViewController {

    // MARK: - Properties
    private lazy var coreDataStack = CoreDataStack()
    private lazy var coreDataManager = CoreDataManager(managedObjectContext: coreDataStack.mainContext,
                                                       coreDataStack: coreDataStack)
    private let emptyStateView = RecipeTableViewEmptyStateView()
    private let refresherControl = UIRefreshControl()
    private let cellIndentifier = RecipeTableViewCell.reuseIdentifier
    private let recipeListEmptyStateView = RecipeTableViewEmptyStateView()
    private let searchController = UISearchController(searchResultsController: nil)

    private var recipeListType: RecipeListType = .favorite
    private var recipes: [Hit] {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - Initializers
    init(recipeListType: RecipeListType, recipes: [Hit]) {
        self.recipeListType = recipeListType
        self.recipes = recipes
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
        configureRefresherControl()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavoriteRecipes()
    }

    // MARK: - Setup
    private func configureTableView() {
        self.tableView.register(RecipeTableViewCell.self, forCellReuseIdentifier: cellIndentifier)
        self.tableView.rowHeight = 250
        self.tableView.separatorStyle = .none
    }

    private func configureSearchController() {
        if recipeListType == .favorite {
            searchController.searchResultsUpdater = self
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.placeholder = Text.tableViewSearchPlaceholder
            searchController.automaticallyShowsSearchResultsController = true
            self.navigationItem.searchController = searchController
            self.definesPresentationContext = true
        }
    }

    private func configureRefresherControl() {
        if recipeListType == .favorite {
            refresherControl.attributedTitle = NSAttributedString(string: Text.favoriteREcipeRefresherTitle)
        refresherControl.tintColor = .label
        self.tableView.refreshControl = refresherControl
        refreshControl?.addTarget(self, action: #selector(fetchFavoriteRecipes), for: .valueChanged)
        }
    }

    // MARK: - CoreData
    @objc func fetchFavoriteRecipes() {
        if recipeListType == .favorite {
            self.recipes = coreDataManager.getRecipes()
            self.refresherControl.endRefreshing()
        }
    }

    private func addFavorite(_ recipe: RecipeClass) {
        coreDataManager.add(recipe: recipe)
    }

    private func removeFavorite(_ recipe: RecipeClass) {
        coreDataManager.delete(recipe)
    }

    // MARK: - TableView Datasource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emptyStateView.isHidden = !recipes.isEmpty
        return recipes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: cellIndentifier,
            for: indexPath) as? RecipeTableViewCell else { return UITableViewCell() }
        let recipes = recipes[indexPath.row].recipe
        cell.configure(with: recipes)
        return cell
    }

    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedRecipe = recipes[indexPath.row].recipe else {return}

        guard let cell = self.tableView.cellForRow(at: indexPath) as? RecipeTableViewCell else {return}
        guard let recipeImage = cell.recipeCardView.recipeImage.image else {return}

        let recipeDetailVC = RecipeDetailViewController(recipe: selectedRecipe, recipeImage: recipeImage)
        recipeDetailVC.isFavorite = recipeListType == .favorite
        navigationController?.pushViewController(recipeDetailVC, animated: true)
    }

    // ContextMenu
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addAction = self.addToFavoriteAction(forRowAtIndexPath: indexPath)
        let removeAction = self.removeFromFavoriteAction(forRowAtIndexPath: indexPath)

        guard let recipe = recipes[indexPath.row].recipe else {return nil}
        let isRecipeFavorite = coreDataManager.verifyRecipeExist(for: recipe)
        let action = isRecipeFavorite ? removeAction : addAction
        let swipeConfig = UISwipeActionsConfiguration(actions: [action])
        return swipeConfig
    }

    // Add
    private func addToFavoriteAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal,
                                        title: Text.addToFavorite) { [weak self] (_, _, completion) in
            guard let self = self else {return}
            guard let recipe = self.recipes[indexPath.row].recipe else {return}
            self.addFavorite(recipe)
            completion(true)
        }
        action.backgroundColor = .systemOrange
        action.image = Icons.favorite
        return action
    }
    // Delete
    private func removeFromFavoriteAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: Text.deleteFavorite) { [weak self] (_, _, completion) in
            guard let self = self else {return}
            guard let recipe = self.recipes[indexPath.row].recipe else {return}
            self.removeFavorite(recipe)
            self.recipes.remove(at: indexPath.row)
            completion(true)
        }
        action.backgroundColor = .systemRed
        action.image = Icons.trash
        return action
    }
}

// MARK: - Search result updater
extension RecipeTableViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {return}
        if recipeListType == .favorite {
            recipes = coreDataManager.getRecipes(with: searchText)
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
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
