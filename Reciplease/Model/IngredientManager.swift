//
//  IngredientManager.swift
//  Reciplease
//
//  Created by Birkyboy on 05/09/2021.
//

import Foundation

protocol IngredientsDelegate: AnyObject {
    var ingredients: [String] { get set }
}

class IngredientManager {

    weak var ingredientDelegate: IngredientsDelegate?
    var ingredients: [String] = []

    // Add
    func addIngredient(for ingredientsName: String) {
        let result = ingredientsName.components(separatedBy: ",")
        result.forEach {
            addToList($0.capitalized)
        }
    }
    // delete
    func deleteIngredient(with name: String) {
        if let index = ingredients.firstIndex(where: {
            $0 == name
        }) {
            ingredients.remove(at: index)
            updateIngredients()
        }
    }
    // deleteAll
    func clearIngredientList() {
        ingredients.removeAll()
        updateIngredients()
    }

    // MARK: - Private functions
    private func addToList(_ ingredientName: String) {
        ingredients.append(ingredientName)
        updateIngredients()
    }

    private func updateIngredients() {
        ingredientDelegate?.ingredients = ingredients
        dump(ingredients)
    }

}
