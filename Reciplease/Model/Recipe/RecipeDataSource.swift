//
//  RecipeDataSource.swift
//  Reciplease
//
//  Created by Birkyboy on 06/09/2021.
//

import Foundation

class RecipeDataSource {

    var recipes: [Hit] = []
    private var ingredientList: String?
    weak var recipeClient: RecipeClient?

    func getRecipes(with ingredientList: String) {
        self.recipeClient?.getRecipes(with: ingredientList, completionHandler: { result in
            switch result {
                case .success(let recipe):
                    guard let recipe = recipe.hits else {return}
                    recipes = recipe
                case .failure(let error):
                    print(error.localizedDescription)
            }
        })
    }
}
