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

    func addIngredient(for ingredientsName: String) {
        let result = ingredientsName.components(separatedBy: ",")
        result.forEach {
            if !$0.isEmpty {
                ingredients.append($0)
            }
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
}
