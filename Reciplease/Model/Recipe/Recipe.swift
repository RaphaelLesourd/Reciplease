//
//  Recipe.swift
//  Reciplease
//
//  Created by Birkyboy on 06/09/2021.
//

import Foundation

// MARK: - Recipe
struct Recipe {
    let hits: [Hit]?
}

struct Hit {
    let recipe: RecipeClass?
}

struct RecipeClass {
    let label: String?
    let image: String?
    let url: String?
    let yield: Int?
    let ingredients: [Ingredient]?
    let totalTime: Int?
}

struct Ingredient {
    let text: String?
}
