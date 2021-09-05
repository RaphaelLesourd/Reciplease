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

    // MARK: - Lifecycle
    override func loadView() {
        view = recipeView
        view.backgroundColor = .secondarySystemBackground
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
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
