//
//  IngredientManager.swift
//  Reciplease
//
//  Created by Birkyboy on 05/09/2021.
//

import Foundation

class IngredientDataSource {

    var ingredients: [String] = [] {
        didSet {
            ingredients = ingredients.sorted { $0 < $1 }
            dump(ingredients)
        }
    }

    func addIngredient(for ingredientsName: String, completion: (IngredientError?) -> Void) {
        guard !ingredientsName.isEmpty else {
            completion(.noName)
            return
        }
        let result = ingredientsName.components(separatedBy: ",")
        result.forEach {
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

    func deleteIngredient(with name: String) {
        if let index = ingredients.firstIndex(where: {
            $0 == name
        }) {
            ingredients.remove(at: index)
        }
    }

    func clearIngredientList() {
        ingredients.removeAll()
    }

    // MARK: - Private function
    private func ingredientAlreadyExist(for ingredientName: String) -> Bool {
        return ingredients.contains(ingredientName)
    }
}
