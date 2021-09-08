//
//  Errors.swift
//  Reciplease
//
//  Created by Birkyboy on 07/09/2021.
//

import Foundation

enum IngredientError: Error {
    case emptyList
    case noName
    case alreadyExist(ingredientName: String)

    var description: String {
        switch self {
        case .noName:
                return "You did not enter any ingredient!"
        case .alreadyExist(let name):
                return "\(name.capitalized) already in your list!"
        case .emptyList:
                return "Please add ingredients in your list before looking for recipes."
        }
    }
}

enum ApiError: Error {
    case badURL
    case responseError
    case decodeError

    var description: String {
        switch self {
        case .responseError:
                return "Error fetching data"
        case .decodeError:
                return "No recipe found"
        case .badURL:
                return "Could not locate the data"
        }
    }
}
