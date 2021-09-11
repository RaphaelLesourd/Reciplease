//
//  BookingClient.swift
//  Reciplease
//
//  Created by Birkyboy on 07/09/2021.
//

import Foundation

class RecipeService {

    private var apiClient: ApiClient

    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }

    func getRecipes(for ingredientList: [String], completion: @escaping (Result<RecipeData, ApiError>) -> Void) {

        let apiURL = URL(string: "https://api.edamam.com/api/recipes/v2")
        let parameters = ["q": ingredientList.joined(separator: ","),
                          "type": "public",
                          "app_id": "51f9801c",
                          "app_key": "32c858b39ceb0df2fadf69b33d49e09c",
                          "from": "0",
                          "to": "50"]

        apiClient.getData(with: apiURL, parameters: parameters) { (result: Result<RecipeData, ApiError>) in
            switch result {
            case .success(let recipes):
                guard let recipeList = recipes.hits, !recipeList.isEmpty else {
                    completion(.failure(.noData))
                    return
                }
                completion(.success(recipes))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
