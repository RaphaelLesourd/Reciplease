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

enum ApiError: Error, Equatable {
    static func == (lhs: ApiError, rhs: ApiError) -> Bool {
        return lhs.description == rhs.description
    }

    case noInputData
    case noData
    case alamofireError(AFError)

    var description: String {
        switch self {
        case .alamofireError(let error):
            return error.errorDescription ?? ""
        case .noInputData:
            return "Please add ingredients in your list before looking for recipes."
        case .noData:
            return "Unable to find anything matching your request."
        }
    }
}
