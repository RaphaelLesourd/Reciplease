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
    static let shared = RecipeService()
    var session: Session
    
    // MARK: - Initializer
    init(session: Session = .default) {
        self.session = session
    }
    
    // MARK: - Fetch methods
    /// Fetch recipes from API for a list of ingredients.
    /// - Parameters:
    ///   - ingredients: List of ingredients.
    ///   - completion: Return result with either a list of recipes or an error of type ApiError.
    func getRecipes(for ingredients: [String], completion: @escaping (Result<RecipeData, ApiError>) -> Void) {
        
        guard !ingredients.isEmpty else {
            completion(.failure(.noImputData))
            return
        }
        // Create a background queue to fetch data.
        let queue = DispatchQueue(label: "com.response-queue", qos: .utility, attributes: [.concurrent])
        // Pass the background queue to the response.
        // AlamoFire's framework completion handler is run on the main thread by default.
        session.request(AlamofireRouter.ingredients(ingredients))
            .validate()
            .responseDecodable(of: RecipeData.self, queue: queue) { response in
                switch response.result {
                case .success(let jsonData):
                    guard let recipeList = jsonData.hits, !recipeList.isEmpty else {
                        completion(.failure(.noData))
                        return
                    }
                    // Return to the main queue to update the UI.
                    DispatchQueue.main.async {
                        completion(.success(jsonData))
                    }
                case .failure(let error):
                    completion(.failure(.afError(error)))
                }
            }
    }
}
