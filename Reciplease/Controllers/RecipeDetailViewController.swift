//
//  RecipeDetailViewController.swift
//  Reciplease
//
//  Created by Birkyboy on 05/09/2021.
//

import UIKit

class RecipeDetailViewController: UIViewController {

    // MARK: - Properties
    private let recipeView = RecipeDetailView()
    private let unFavoriteIcon = UIImage(systemName: "star")
    private let favoriteIcon = UIImage(systemName: "star.fill")
    private var isFavorite = true
    private var addToFavoriteButton: UIBarButtonItem?
    private var recipe: RecipeClass
    private var headerView = RecipeDetailHeaderView()
    private var imageClient = ImageClient()

    // MARK: - Intializers
    init(recipe: RecipeClass) {
        self.recipe = recipe
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
        configureNavigationItem()
        setDelegates()
    }

    // MARK: - Setup
    private func configureNavigationItem() {
        addToFavoriteButton = UIBarButtonItem(image: unFavoriteIcon,
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(favoriteButtonTapped))
        addToFavoriteButton?.tintColor = .systemOrange
        navigationItem.rightBarButtonItem = addToFavoriteButton
    }

    private func setDelegates() {
        recipeView.tableView.delegate = self
        recipeView.tableView.dataSource = self
    }

    // MARK: - Targets
    @objc private func favoriteButtonTapped() {
        toggleFavoriteButtonImage()
        isFavorite.toggle()
    }

    // MARK: - Update view
    private func toggleFavoriteButtonImage() {
        addToFavoriteButton?.image = isFavorite ? favoriteIcon : unFavoriteIcon
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

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.backgroundColor = .clear
        cell.textLabel?.numberOfLines = 0
        let ingredient = recipe.ingredientLines?[indexPath.row]
        if let ingredient = ingredient {
            cell.textLabel?.text = "• \(ingredient)"
        }
        return cell
    }
}

// MARK: - TableView Delegate
extension RecipeDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: RecipeDetailHeaderView.reuseIdentifier) as? RecipeDetailHeaderView
        else { return nil }

        if let rating = recipe.yield, rating > 0 {
            view.recipeCardView.recipeInfoView.ratingLabel.text = "\(rating)"
        } else {
            view.recipeCardView.recipeInfoView.ratingStackView.isHidden = true
        }

        if let cookingTime = recipe.totalTime, cookingTime > 0 {
            view.recipeCardView.recipeInfoView.recipeTimeLabel.text = "\(cookingTime)'"
        } else {
            view.recipeCardView.recipeInfoView.recipeTimeStackView.isHidden = true
        }

        view.recipeCardView.recipeNameLabel.text = recipe.label
        view.recipeCardView.recipeIngredientsLabel.text = "Ingredients"

        imageClient.getImage(with: recipe.image) { result in
            switch result {
            case .success(let image):
                    view.recipeCardView.recipeImage.image = image
            case .failure(_):
                    view.recipeCardView.recipeImage.image = UIImage(named: "EmptyStateCellImage")
            }
        }
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return view.bounds.width * 0.9
    }
}