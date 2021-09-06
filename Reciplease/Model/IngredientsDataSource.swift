//
//  IngredientManager.swift
//  Reciplease
//
//  Created by Birkyboy on 05/09/2021.
//

import Foundation

protocol ErrorDelegate: AnyObject {
    func presentErrorAlert(with message: String)
}

class IngredientDataSource {

    weak var errorDelegate: ErrorDelegate?
    var ingredients: [String] = [] {
        didSet {
            ingredients = ingredients.sorted { $0 < $1 }
            dump(ingredients)
        }
    }

    func addIngredient(for ingredientsName: String) {
        let result = ingredientsName.components(separatedBy: ",")
        result.forEach {
            guard !$0.isEmpty else {
                errorDelegate?.presentErrorAlert(with: "You did not enter any ingredient!")
                return
            }
            guard !ingredientAlreadyExist(for: $0.capitalized) else {
                errorDelegate?.presentErrorAlert(with: "\($0.capitalized) already in your list!")
                return
            }
            ingredients.append($0.capitalized)
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
