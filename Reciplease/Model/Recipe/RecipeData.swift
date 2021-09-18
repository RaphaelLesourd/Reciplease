//
//  Recipe.swift
//  Reciplease
//
//  Created by Birkyboy on 06/09/2021.
//

import Foundation

// MARK: - Recipe
struct RecipeData: Decodable {
    let hits: [Hit]?
}

struct Hit: Decodable, Equatable {
    static func == (lhs: Hit, rhs: Hit) -> Bool {
        return lhs.recipe?.label == rhs.recipe?.label
    }
    let recipe: RecipeClass?
}

struct RecipeClass: Decodable {
    let label: String?
    let image: String?
    let url: String?
    let yield: Int?
    let ingredientLines: [String]?
    let totalTime: Int?
}

