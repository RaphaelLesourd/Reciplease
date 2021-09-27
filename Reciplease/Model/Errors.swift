//
//  Errors.swift
//  Reciplease
//
//  Created by Birkyboy on 07/09/2021.
//

import Foundation
import Alamofire
import AlamofireImage

enum IngredientError: Error {
    case noName
    case alreadyExist(ingredientName: String)
}
extension IngredientError: LocalizedError {
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
    case noImputData
    case noData
    case afError(AFError)
 
    static func == (lhs: ApiError, rhs: ApiError) -> Bool {
        return lhs.description == rhs.description
    }
}

extension ApiError: LocalizedError {
    var description: String {
        switch self {
        case .noImputData:
            return "You have not provided any ingredients yet."
        case .noData:
            return "Unable to find anything matching your request."
        case .afError(let error):
            return error.localizedDescription.description
        }
    }
}
