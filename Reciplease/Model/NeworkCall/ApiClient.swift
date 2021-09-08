//
//  RecipeService.swift
//  Reciplease
//
//  Created by Birkyboy on 06/09/2021.
//

import Foundation
import Alamofire

class ApiClient {

    let alamoFireManager = Session(configuration: .default,
                                   delegate: SessionDelegate(),
                                   startRequestsImmediately: true)

    func getData<T: Decodable>(with apiURL: URL?, completion: @escaping (Result<T,ApiError>) -> Void) {
        guard let apiURL = apiURL else {
            completion(.failure(.badURL))
            return
        }
        alamoFireManager.request(apiURL, method: .get)
            .validate()
            .responseDecodable(of:T.self) { response in
            switch response.result {
            case .success(let jsonData):
                completion(.success(jsonData))
            case .failure(let error):
                completion(.failure(.alamofireError(error)))
            }
        }
    }
}
