//
//  BookingClient.swift
//  Reciplease
//
//  Created by Birkyboy on 07/09/2021.
//

import Foundation
import Alamofire

class RecipeService {

    private let session: Session

    init(session: Session = .default) {
        self.session = session
    }

    func getRecipes(for ingredientList: [String], completion: @escaping (Result<RecipeData, ApiError>) -> Void) {

        let apiURL = URL(string: "https://api.edamam.com/api/recipes/v2")
        let parameters = ["q": ingredientList.joined(separator: ","),
                          "type": "public",
                          "app_id": "51f9801c",
                          "app_key": "32c858b39ceb0df2fadf69b33d49e09c"]

        guard let apiURL = apiURL else {
            completion(.failure(.badURL))
            return
        }
        session.request(apiURL, method: .get, parameters: parameters)
            .validate()
            .responseDecodable(of: RecipeData.self) { response in
                switch response.result {
                case .success(let jsonData):
                        guard let recipeList = jsonData.hits, !recipeList.isEmpty else {
                            completion(.failure(.noData))
                            return
                        }
                        completion(.success(jsonData))
                case .failure(let error):
                        completion(.failure(.alamofireError(error)))
                }
            }
    }
}
