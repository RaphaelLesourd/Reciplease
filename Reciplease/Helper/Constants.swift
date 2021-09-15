//
//  Constants.swift
//  Reciplease
//
//  Created by Birkyboy on 05/09/2021.
//

import Foundation
import UIKit

// MARK: - Recipelist types
enum RecipeListType {
    case favorite
    case search
}
// MARK: - Recipelist types
enum AlertType: String {
    case success = "Success"
    case error = "Error !"
}
// MARK: - Images
enum DefaultImages {
    static let recipe = UIImage(named: "EmptyStateCellImage")
    static let emptyState = UIImage(named: "EmptyState_Icon")
}

enum Icons {
    static let notFavorite = UIImage(systemName: "star")
    static let favorite = UIImage(systemName: "star.fill")
    static let trash = UIImage(systemName: "trash.fill")
    static let timer = UIImage(systemName: "timer")
}
// MARK: - Text string
enum Text {
    static let noData = "--"
    static let detailViewIngredientTitle = "Ingredients"
    static let tableViewSearchPlaceholder = "Search for recipes"
    static let addToFavorite = "Add to favorites"
    static let deleteFavorite = "Remove from favorites"
    static let add = "ADD"
    static let addIngredientPlaceholder = "Lemon, Cheese, Sausages..."
    static let emptyStateMessage = "Nothing here yet!"
    static let clearButtonTitle = "Clear"
    static let ingredientListTitle = "Your ingredients"
    static let searchRecipeButton = "Search for recipe"
    static let getDirectionButton = "Get directions"
}

enum TabBar {
    enum Icons {
        static let searchIcon = UIImage(systemName: "magnifyingglass")!
        static let favoriteIcon = UIImage(systemName: "star")!
    }
    enum Text {
        static let search = "Search"
        static let favorite = "Favorite"
    }
}
