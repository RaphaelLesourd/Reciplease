//
//  BookingClient.swift
//  Reciplease
//
//  Created by Birkyboy on 07/09/2021.
//

import Foundation
import Alamofire

class RecipeService {
    
    // MARK: - Properties
    static let shared = RecipeService(session: .default)
    private let apiURL = URL(string: "https://api.edamam.com/api/recipes/v2")
    
    /// Create session
    private var session: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 20
        return Session(configuration: configuration)
    }()
    
    // MARK: - Initializer
    init(session: Session) {
        self.session = session
    }
    
    // MARK: - Fetch methods
    /// Fetch recipes from API for a list of ingredients.
    /// - Parameters:
    ///   - ingredients: List of ingredients.
    ///   - completion: Return result with either a list of recipes or an error of type ApiError.
    func getRecipes(for ingredients: [String]?, completion: @escaping (Result<RecipeData, ApiError>) -> Void) {
        guard let ingredients = ingredients else {
            completion(.failure(.noInputData))
            return
        }
        let parameters = configureQueryParameters(with: ingredients)
        guard let apiURL = apiURL else { return }
        
        session.request(apiURL, method: .get, parameters: parameters)
            .validate()
            .responseDecodable(of: RecipeData.self) { response in
                switch response.result {
                case .success(let jsonData):
                    guard let recipeList = jsonData.hits, !recipeList.isEmpty else {
                        completion(.failure(.noData))
                        return
                    }
                    DispatchQueue.main.async {
                        completion(.success(jsonData))
                    }
                case .failure(let error):
                    completion(.failure(.alamofireError(error)))
                }
            }
    }
    
    /// Set  alamofire query parameters
    /// - Parameter ingredients: Pass in list of ingredients.
    /// - Returns: Return a dictionnary of query parameters.
    private func configureQueryParameters(with ingredients: [String]) -> [String : Any] {
        let parameters = ["q": ingredients.joined(separator: ","),
                          "type": "public",
                          "ingr": ingredients.count + 1,
                          "app_id": ApiKey.appID,
                          "app_key": ApiKey.appKey] as [String : Any]
        return parameters
    }
}
