//
//  RecipeDetailViewController.swift
//  Reciplease
//
//  Created by Birkyboy on 05/09/2021.
//

import UIKit

class RecipeDetailViewController: UIViewController {

    // MARK: - Properties
    private lazy var coreDataStack = CoreDataStack()
    private lazy var coreDataManager = CoreDataManager(managedObjectContext: coreDataStack.mainContext,
                                                       coreDataStack: coreDataStack)
    private let recipeView = RecipeDetailView()
    private let headerView = RecipeDetailHeaderView()

    private var recipeImage: UIImage
    private var addToFavoriteButton: UIBarButtonItem?
    private var recipe: RecipeClass
    var isFavorite = false

    // MARK: - Intializers
    init(recipe: RecipeClass, recipeImage: UIImage) {
        self.recipe = recipe
        self.recipeImage = recipeImage
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func loadView() {
        view = recipeView
        view.backgroundColor = .secondarySystemBackground
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        configureNavigationItem()
        setGetDirectionButtonTarget()
        toggleFavoriteButtonImage()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // MARK: - Setup
    private func configureNavigationItem() {
        addToFavoriteButton = UIBarButtonItem(image: Icons.notFavorite,
                                              style: .plain,
                                              target: self,
                                              action: #selector(favoriteButtonTapped))
        addToFavoriteButton?.tintColor = .systemOrange
        navigationItem.rightBarButtonItem = addToFavoriteButton
    }

    private func setGetDirectionButtonTarget() {
        recipeView.directionButton.addTarget(self, action: #selector(getDirections), for: .touchUpInside)
    }

    private func setDelegates() {
        recipeView.tableView.delegate = self
        recipeView.tableView.dataSource = self
    }
    // MARK: - Targets
    @objc private func favoriteButtonTapped() {
        isFavorite ? removeFromFavorite() : addToFavorite()
        isFavorite.toggle()
        toggleFavoriteButtonImage()
    }

    private func addToFavorite() {
        coreDataManager.add(recipe: recipe)
    }

    private func removeFromFavorite() {
        do {
            try coreDataManager.delete(recipe)
        } catch let error {
            presentMessageAlert(with: error.localizedDescription)
        }
    }

    @objc private func getDirections() {
        guard let linkURL = recipe.url,
              let recipeURL = URL(string: linkURL),
              UIApplication.shared.canOpenURL(recipeURL)
        else {
            return presentMessageAlert(with: ApiError.noRecipeFound.description)
        }
        UIApplication.shared.open(recipeURL, options: [:], completionHandler: nil)
    }

    // MARK: - Update view
    private func toggleFavoriteButtonImage() {
        isFavorite = coreDataManager.verifyRecipeExist(for: recipe)
        addToFavoriteButton?.image = isFavorite ? Icons.favorite : Icons.notFavorite
    }
}

// MARK: - TableView datasource
extension RecipeDetailViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe.ingredientLines?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.backgroundColor = .clear
        cell.textLabel?.numberOfLines = 0
        if let ingredient = recipe.ingredientLines?[indexPath.row] {
            cell.textLabel?.text = "• \(ingredient)"
        }
        return cell
    }
}
// MARK: - TableView Delegate
extension RecipeDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: RecipeDetailHeaderView.reuseIdentifier) as? RecipeDetailHeaderView
        else { return nil }

        if let rating = recipe.yield, rating > 0 {
            view.recipeCardView.recipeInfoView.ratingLabel.text = "\(rating)"
        } else {
            view.recipeCardView.recipeInfoView.ratingStackView.isHidden = true
        }

        if let cookingTime = recipe.totalTime, cookingTime > 0 {
            let time = Double(cookingTime).asString(style: .abbreviated)
            view.recipeCardView.recipeInfoView.recipeTimeLabel.text = "\(time)"
        } else {
            view.recipeCardView.recipeInfoView.recipeTimeStackView.isHidden = true
        }
        view.recipeCardView.recipeIngredientsLabel.text = Text.detailViewIngredientTitle
        view.recipeCardView.recipeNameLabel.text = recipe.label
        view.recipeCardView.recipeImage.image = recipeImage
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return view.bounds.width * 0.9
    }
}
