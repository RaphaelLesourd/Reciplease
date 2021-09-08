//
//  BookingClient.swift
//  Reciplease
//
//  Created by Birkyboy on 07/09/2021.
//

import Foundation

class RecipeClient {

    let apiClient = ApiClient()

    func getRecipes(with ingredientList: [String], completionHandler: @escaping (Result<Recipe, ApiError>) -> Void) {
        guard !ingredientList.isEmpty else {
            return completionHandler(.failure(.decodeError))
        }
        let apiURL = createRecipeRequestUrl(with: ingredientList)
        apiClient.getData(with: apiURL) { (result: Result<Recipe, ApiError>) in
            completionHandler(result)
        }
    }

    func createRecipeRequestUrl(with ingredientList: [String]) -> URL? {

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.edamam.com"
        urlComponents.path = "/api/recipes/v2"
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: ingredientList.joined(separator: ", ")),
            URLQueryItem(name: "type", value: "public"),
            URLQueryItem(name: "app_id", value: "51f9801c"),
            URLQueryItem(name: "app_key", value: "32c858b39ceb0df2fadf69b33d49e09c"),
            URLQueryItem(name: "from", value: "0"),
            URLQueryItem(name: "to", value: "50")
        ]
        return urlComponents.url
    }
}
