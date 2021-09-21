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

    let apiURL = URL(string: "https://api.edamam.com/api/recipes/v2")

    func getRecipes(for ingredientList: [String]?, completion: @escaping (Result<RecipeData, ApiError>) -> Void) {

        guard let ingredients = ingredientList else {
            completion(.failure(.noInputData))
            return
        }
        let parameters = ["q": ingredients.joined(separator: ","),
                          "type": "public",
                          "app_id": ApiKey.appID,
                          "app_key": ApiKey.appKey]

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
                        completion(.success(jsonData))
                case .failure(let error):
                        completion(.failure(.alamofireError(error)))
                }
            }
    }
}
