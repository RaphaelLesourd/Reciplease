//
//  BookingClient.swift
//  Reciplease
//
//  Created by Birkyboy on 07/09/2021.
//

import Foundation

class RecipeRequest {

    let apiClient = ApiClient()

    func getRecipes(with ingredientList: [String], completion: @escaping (Result<RecipeData, ApiError>) -> Void) {
        guard !ingredientList.isEmpty else {
            return completion(.failure(.noInputData))
        }
        let apiURL = createRecipeRequestUrl(with: ingredientList)
        apiClient.getData(with: apiURL) { (result: Result<RecipeData, ApiError>) in
            completion(result)
        }
    }

    func createRecipeRequestUrl(with ingredientList: [String]) -> URL? {

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.edamam.com"
        urlComponents.path = "/api/recipes/v2"
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: ingredientList.joined(separator: ",")),
            URLQueryItem(name: "type", value: "public"),
            URLQueryItem(name: "app_id", value: "51f9801c"),
            URLQueryItem(name: "app_key", value: "32c858b39ceb0df2fadf69b33d49e09c"),
            URLQueryItem(name: "from", value: "0"),
            URLQueryItem(name: "to", value: "10")
        ]
        return urlComponents.url
    }
}
