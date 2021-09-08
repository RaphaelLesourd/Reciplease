//
//  IngredientManager.swift
//  Reciplease
//
//  Created by Birkyboy on 05/09/2021.
//

import Foundation

class IngredientManager {

    /// Ingredients list.
    /// - Note: The list is sorte alphabetivally as ingredients are added.
    var ingredients: [String] = [] {
        didSet {
            ingredients = ingredients.sorted { $0 < $1 }
            dump(ingredients)
        }
    }
    /// Add ingredient to the ingredients array
    /// - Parameters:
    ///   - ingredientsName: Name of the ingredient, can be a single ingredient or several ingredients separated by a comma.
    ///   - completion: Return an error is needed.
    func addIngredient(with ingredientsName: String, completion: (IngredientError?) -> Void) {
        guard !ingredientsName.isEmpty else {
            completion(.noName)
            return
        }
        let ingredientList = ingredientsName.components(separatedBy: ",")
        ingredientList.forEach {
            guard !ingredientAlreadyExist(for: $0.capitalized) else {
                completion(.alreadyExist(ingredientName: $0))
                return
            }
            if !$0.isEmpty {
                ingredients.append($0.capitalized)
            }
            completion(nil)
        }
    }
    /// Delete ingrdient from ingredient list.
    /// - Parameter name: Name of the ingredient.
    func deleteIngredient(with name: String) {
        if let index = ingredients.firstIndex(where: {
            $0 == name
        }) {
            ingredients.remove(at: index)
        }
    }
    /// Delete all ingrdients from the list.
    func clearIngredientList() {
        ingredients.removeAll()
    }

    // MARK: - Private function
    /// Check if an ingredient is already in the list.
    /// - Parameter ingredientName: Ingredient name.
    /// - Returns: True or false
    private func ingredientAlreadyExist(for ingredientName: String) -> Bool {
        return ingredients.contains(ingredientName)
    }
}
