//
//  Errors.swift
//  Reciplease
//
//  Created by Birkyboy on 07/09/2021.
//

import Foundation
import Alamofire

protocol ErrorPresenter: AnyObject {
    func presentMessageAlert(type: AlertType, with message: String)
}

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

enum ApiError: Error {
    case noInputData
    case noData
    case noRecipeFound
    case badURL
    case alamofireError(AFError)

    var description: String {
        switch self {
        case .badURL:
            return "Could not locate the data"
        case .alamofireError(let error):
            return error.errorDescription ?? ""
        case .noInputData:
            return "Please add ingredients in your list before looking for recipes."
        case .noData:
            return "Unable to find anything matching your request."
        case .noRecipeFound:
            return "Unable to get directions"
        }
    }
}

enum CoredataError: Error {
    case recipeExist
    case savingFailed
    case retreiveFailed
    case deletingFailed

    var description: String {
        switch self {
        case .recipeExist:
            return "This recipe already one your favorites."
        case .savingFailed:
            return "Unable to add this recipe to your favorites."
        case .retreiveFailed:
            return "unable to find your favorite recipe."
        case .deletingFailed:
            return "Unable to delete this recipe from your favorites."
        }
    }
}
