//
//  Errors.swift
//  Reciplease
//
//  Created by Birkyboy on 07/09/2021.
//

import Foundation

enum IngredientError: Error {
    case noName
    case alreadyExist(ingredientName: String)

    var description: String {
        switch self {
        case .noName:
            return "You did not enter any ingredient!"
        case .alreadyExist(let name):
            return "\(name.capitalized) already in your list!"
        }
    }
}
