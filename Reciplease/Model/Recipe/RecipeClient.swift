//
//  BookingClient.swift
//  Reciplease
//
//  Created by Birkyboy on 07/09/2021.
//

import Foundation

protocol SearchDelegate: AnyObject {
    func navigateToRecipeList(with recipes: [Hit])
    func stopActivityIndicator()
}

class RecipeClient {

    private var apiClient: ApiClient
    weak var errorPresenter: ErrorPresenter?
    weak var searchDelegate : SearchDelegate?

    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }

    func getRecipes(with ingredientList: [String]) {
        guard !ingredientList.isEmpty else {
            errorPresenter?.presentErrorAlert(with: ApiError.noInputData.description)
            searchDelegate?.stopActivityIndicator()
            return
        }
        let apiURL = createRecipeRequestUrl(with: ingredientList)
        apiClient.getData(with: apiURL) { [weak self] (result: Result<RecipeData, ApiError>) in
            guard let self = self else {return}
            self.searchDelegate?.stopActivityIndicator()
            switch result {
            case .success(let recipes):
                    guard let recipes = recipes.hits, !recipes.isEmpty else {
                        self.errorPresenter?.presentErrorAlert(with: ApiError.noData.description)
                        return
                    }
                    self.searchDelegate?.navigateToRecipeList(with: recipes)
            case .failure(let error):
                    self.errorPresenter?.presentErrorAlert(with: error.description)
            }
        }
    }

    private func createRecipeRequestUrl(with ingredientList: [String]) -> URL? {
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
            URLQueryItem(name: "to", value: "50")
        ]
        return urlComponents.url
    }
}
