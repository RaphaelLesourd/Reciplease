//
//  IngredientManager.swift
//  Reciplease
//
//  Created by Birkyboy on 05/09/2021.
//

import Foundation

class IngredientManager {

    /// Ingredients list Array
    var ingredients: [String] = []

    /// Add ingredient to the ingredients array
    /// - Parameters:
    ///   - ingredientsName: Name of the ingredient, can be a single ingredient or several ingredients separated by a comma.
    ///   - completion: Return an error is needed.
    func addIngredient(with ingredientsName: String, completion: (IngredientError?) -> Void) {
        guard !ingredientsName.isEmpty else {
            return completion(.noName)
        }
        let ingredientList = ingredientsName.components(separatedBy: ",")
        ingredientList.forEach {
            guard !ingredientAlreadyExist(for: $0.capitalized) else {
                return completion(.alreadyExist(ingredientName: $0))
            }
            if !$0.isEmpty {
                ingredients.append($0.capitalized.trimmingCharacters(in: .whitespacesAndNewlines))
                ingredients = ingredients.sorted { $0 < $1 }
            }
            completion(nil)
        }
    }
    /// Delete ingrdient from ingredient list.
    /// - Parameter name: Name of the ingredient.
    func deleteIngredient(with name: String) {
        if let index = ingredients.firstIndex(where: { $0 == name }) {
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
