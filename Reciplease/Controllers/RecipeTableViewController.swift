//
//  TableViewController.swift
//  Reciplease
//
//  Created by Birkyboy on 05/09/2021.
//

import UIKit

class RecipeTableViewController: UITableViewController {

    // MARK: - Properties
    private lazy var coreDataManager = CoreDataManager(managedObjectContext: AppDelegate.context)
    private let emptyStateView = RecipeTableViewEmptyStateView()
    private let refresherControl = UIRefreshControl()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let cellIndentifier = RecipeTableViewCell.reuseIdentifier
    private let recipeListEmptyStateView = RecipeTableViewEmptyStateView()
    private let searchController = UISearchController(searchResultsController: nil)

    private var favoriteRecipeSortButton: UIBarButtonItem?
    private var recipeListType: RecipeListType = .favorite
    private var searchText = ""
    private var isAscending = false {
        didSet {
            fetchFavoriteRecipes()
        }
    }
    private var originalRecipeList: [RecipeClass] = []
    private var recipes: [RecipeClass] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    // MARK: - Initializers
    /// Intialize the controller with a list of recipes and type of recipes
    /// - Parameters:
    ///   - recipeListType: Type of recipes, by default .favorite
    ///   - recipes: List of recepies received from the SearchViewController
    init(recipeListType: RecipeListType, recipes: [RecipeClass]) {
        self.recipeListType = recipeListType
        self.recipes = recipes
        self.originalRecipeList = recipes
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
        configureSearchController()
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
        favoriteRecipeSortButton = UIBarButtonItem(image: Icons.sortIcon,
                                                   style: .plain,
                                                   target: self,
                                                   action: #selector(sortFavoriteRecipes))
        favoriteRecipeSortButton?.tintColor = .label
        navigationItem.leftBarButtonItem = favoriteRecipeSortButton
    }

    // MARK: - CoreData
    @objc func fetchFavoriteRecipes() {
        if recipeListType == .favorite {
            showIndicator(activityIndicator)
            activityIndicator.hidesWhenStopped = true
            do {
                self.recipes = try coreDataManager.getRecipes(with: searchText, ascending: isAscending)
                
            } catch let error {
                self.presentMessageAlert(with: error.localizedDescription)
            }
            hideIndicator(activityIndicator)
            self.refresherControl.endRefreshing()
        }
    }

    private func addFavorite(_ recipe: RecipeClass) {
        coreDataManager.add(recipe: recipe)
    }

    private func removeFavorite(_ recipe: RecipeClass, at indexPath: IndexPath) {
        do {
            try coreDataManager.delete(recipe)
            if self.recipeListType == .favorite {
                self.recipes.remove(at: indexPath.row)
            }
        } catch let error {
            presentMessageAlert(with: error.localizedDescription)
        }
    }

    @objc private func sortFavoriteRecipes() {
        isAscending.toggle()
    }

    // MARK: - Navigation
    private func navigateToDetailViewController(with selectedRecipe: RecipeClass, and recipeImage: UIImage) {
        let isRecipeFavorite = recipeListType == .favorite
        let recipeDetailVC = RecipeDetailViewController(recipe: selectedRecipe,
                                                        recipeImage: recipeImage,
                                                        isFavorite: isRecipeFavorite)
        navigationController?.pushViewController(recipeDetailVC, animated: true)
    }
}

// MARK: - TableView Datasource & Delegate
extension RecipeTableViewController {
    
    // Datasource
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
        let recipe = recipes[indexPath.row]
        cell.configure(with: recipe)
        return cell
    }

    // Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRecipe = recipes[indexPath.row]
        guard let cell = self.tableView.cellForRow(at: indexPath) as? RecipeTableViewCell else {return}
        guard let recipeImage = cell.recipeCardView.recipeImage.image else {return}

        navigateToDetailViewController(with: selectedRecipe, and: recipeImage)
    }

    // Add a context ContextMenu to be able to add or remove a favorite recipe from coredata.
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Checks if recipe exits in coredata
        let recipe = recipes[indexPath.row]
        let isRecipeFavorite = coreDataManager.verifyRecipeExist(for: recipe)

        let action = self.contextMenuAction(isFavorite: isRecipeFavorite, forRowAtIndexPath: indexPath)
        let swipeConfig = UISwipeActionsConfiguration(actions: [action])
        return swipeConfig
    }
    
    /// Tableview context menu actions.
    /// - Parameters:
    ///   - isFavorite: Pass in Bool value if recipe at indexPath is already a favorite recipe.
    ///   - indexPath: Index of the recipe
    /// - Returns: Contextual menu action
    private func contextMenuAction(isFavorite: Bool, forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let actionTitle = isFavorite ? Text.deleteFavorite : Text.addToFavorite
        let action = UIContextualAction(style: .normal, title: actionTitle) { [weak self] (_, _, completion) in
            guard let self = self else {return}
            let recipe = self.recipes[indexPath.row]
            if isFavorite {
                self.removeFavorite(recipe, at: indexPath)
            } else {
                self.addFavorite(recipe)
            }
            completion(true)
        }
        action.backgroundColor = isFavorite ? .systemRed : .favoriteColor
        action.image = isFavorite ? Icons.trash : Icons.favorite
        return action
    }
}

// MARK: - Search result updater
extension RecipeTableViewController: UISearchResultsUpdating {
    
    /// Upadate the tableView according to the text entered in the UISearchControler textField
    /// - Parameter searchController: Pass in the search controller used.
   func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {return}
        // If the recipe list type is favorite, the recipe stored in coredata are fetch according the the searchText criteria.
       if recipeListType == .favorite {
            self.searchText = searchText
            fetchFavoriteRecipes()
        } else {
            // Otherwise if recipe list type is not favorite, the searched recipes are filtered.
            filterSearchedRecipes(for: searchText)
        }
    }
    
    /// Filter the recipe searched
    /// - Parameter searchText: Pass in the text used to filter recipes.
    private func filterSearchedRecipes(for searchText: String) {
        if searchText.isEmpty {
            recipes = originalRecipeList
        } else {
            recipes = originalRecipeList.filter({
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
        tableView.addSubview(emptyStateView)
        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 150),
            emptyStateView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor)
        ])
    }
}
