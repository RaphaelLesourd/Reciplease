//
//  ViewController.swift
//  Reciplease
//
//  Created by Birkyboy on 04/09/2021.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK: - Properties

    private let searchView = SearchView()

    // MARK: - Lifecycle

    override func loadView() {
        view = searchView
        view.backgroundColor = .secondarySystemBackground
        title = "Reciplease"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtonTargets()
    }

    // MARK: - Setup
    private func configureButtonTargets() {
        searchView.searchButton.addTarget(self, action: #selector(navigateToRecipeList), for: .touchUpInside)
    }

    // MARK: - Target
    @objc private func navigateToRecipeList() {
        let recipeListVC = RecipeTableViewController()
        show(recipeListVC, sender: self)
    }
}
