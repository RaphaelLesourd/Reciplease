//
//  FakeData.swift
//  RecipleaseTests
//
//  Created by Birkyboy on 20/09/2021.
//

import Foundation
@testable import Reciplease

class FakeData {

    static var recipeCorrectData: Data? {
        let bundle = Bundle(for: FakeData.self)
        let url = bundle.url(forResource: "FakeRecipe", withExtension: "json")!
        return try? Data(contentsOf: url)
    }

    static var emptyRecipeCorrectData: Data? {
        let bundle = Bundle(for: FakeData.self)
        let url = bundle.url(forResource: "FakeEmptyRecipe", withExtension: "json")!
        return try? Data(contentsOf: url)
    }

    static let recipeIncorrectData = "incorrectData".data(using: .utf8)!
    
    class ApiError: Error {}
    static let error = ApiError()
}
