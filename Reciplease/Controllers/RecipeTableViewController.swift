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

    private var favoriteRecipeSortButton: UIBarButtonItem?
    private var recipeListType: RecipeListType = .favorite
    private var searchText = ""
    private var isAscending = false {
        didSet {
            recipes = coreDataManager.getRecipes(with: searchText, ascending: isAscending)
        }
    }
    private var recipes: [Hit] {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - Initializers

    /// Intialize the controller with a list of recipes and type of recipes
    /// - Parameters:
    ///   - recipeListType: Type of recipes, by default .favorite
    ///   - recipes: List of recepies received from the SearchViewController
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
        configureTableView()
        setEmptyStateViewConstraints()
        configureUiForFavoriteRecipes()
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

    /// Configure the functionalities for favorite recipes.
    private func configureUiForFavoriteRecipes() {
        if recipeListType == .favorite {
            addKeyboardDismissGesture()
            configureSearchController()
            configureRefresherControl()
            configureNavigationItem()
        }
    }
    // All setup functions below are set when the recipeListType is set to favorite.
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Text.tableViewSearchPlaceholder
        searchController.automaticallyShowsSearchResultsController = true
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
    }

    private func configureRefresherControl() {
        refresherControl.attributedTitle = NSAttributedString(string: Text.favoriteREcipeRefresherTitle)
        refresherControl.tintColor = .label
        self.tableView.refreshControl = refresherControl
        refreshControl?.addTarget(self, action: #selector(fetchFavoriteRecipes), for: .valueChanged)
    }

    private func configureNavigationItem() {
        favoriteRecipeSortButton = UIBarButtonItem(image: Icons.arrowDown,
                                                   style: .plain,
                                                   target: self,
                                                   action: #selector(sortFavoriteRecipes))
        favoriteRecipeSortButton?.tintColor = .label
        navigationItem.rightBarButtonItem = favoriteRecipeSortButton
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

    @objc private func sortFavoriteRecipes() {
        isAscending.toggle()
        favoriteRecipeSortButton?.image = isAscending ? Icons.arrowUp : Icons.arrowDown
    }

    // MARK: Navigation
    private func navigateToDetailViewController(with selectedRecipe: RecipeClass, and recipeImage: UIImage) {

        let recipeDetailVC = RecipeDetailViewController(recipe: selectedRecipe, recipeImage: recipeImage)
        recipeDetailVC.isFavorite = recipeListType == .favorite
        navigationController?.pushViewController(recipeDetailVC, animated: true)
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

        navigateToDetailViewController(with: selectedRecipe, and: recipeImage)
    }

    // Add a context ContextMenu to be able to add or remove a favorite recipe from coredata.
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Checks if recipe exits in coredata
        guard let recipe = recipes[indexPath.row].recipe else {return nil}
        let isRecipeFavorite = coreDataManager.verifyRecipeExist(for: recipe)

        let action = self.contextMenuAction(isFavorite: isRecipeFavorite, forRowAtIndexPath: indexPath)
        let swipeConfig = UISwipeActionsConfiguration(actions: [action])
        return swipeConfig
    }

    private func contextMenuAction(isFavorite: Bool, forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {

        let actionTitle = isFavorite ? Text.deleteFavorite : Text.addToFavorite
        let action = UIContextualAction(style: .normal, title: actionTitle) { [weak self] (_, _, completion) in
            guard let self = self else {return}
            guard let recipe = self.recipes[indexPath.row].recipe else {return}
            if isFavorite {
                self.removeFavorite(recipe)
                self.recipes.remove(at: indexPath.row)
            } else {
                self.addFavorite(recipe)
            }
            completion(true)
        }
        action.backgroundColor = isFavorite ? .systemRed : .systemOrange
        action.image = isFavorite ? Icons.trash : Icons.favorite
        return action
    }
}

// MARK: - Search result updater
extension RecipeTableViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {return}
        self.searchText = searchText
        recipes = coreDataManager.getRecipes(with: self.searchText, ascending: isAscending)
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
