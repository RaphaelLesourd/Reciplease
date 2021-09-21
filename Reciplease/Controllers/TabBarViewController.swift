//
//  TabBarViewController.swift
//  Reciplease
//
//  Created by Birkyboy on 05/09/2021.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        configureViewControllers()
    }
    /// Set up the tabBar appearance with standard darkmode compatible colors.
    private func configureTabBar() {
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
    }

    private func configureViewControllers() {
        let searchIconImage = TabBar.Icons.searchIcon
        let searchViewController = createController(for: SearchViewController(),
                                                    title: TabBar.Text.search,
                                                    image: searchIconImage)

        let favoriteIconImage = TabBar.Icons.favoriteIcon
        let recipeTableViewController = createController(for: RecipeTableViewController(recipeListType: .favorite, recipes: []),
                                                         title: TabBar.Text.favorite,
                                                         image: favoriteIconImage)
        self.viewControllers = [searchViewController, recipeTableViewController]
    }
    /// Create a navigation controller  for each tab with an icon inmage and a title.
    /// Large title have been set as default to keep the iOS look and feel.
    /// - Parameters:
    ///   - rootViewController: Name of the ViewController assiciated to the tab
    ///   - title: Title name of the tab
    ///   - image: Name of the image
    /// - Returns: A modified ViewController
    private func createController(for rootViewController: UIViewController,
                                  title: String,
                                  image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = false
        rootViewController.navigationItem.title = title
        return navController
    }

}
