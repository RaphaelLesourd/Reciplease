//
//  RecipeService.swift
//  Reciplease
//
//  Created by Birkyboy on 06/09/2021.
//

import Foundation
import Alamofire

class ApiClient {

    let sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 30
        configuration.waitsForConnectivity = true
        return Session(configuration: configuration)
    }()

    func getData<T: Decodable>(with apiURL: URL?,
                               parameters: [String: String],
                               completion: @escaping (Result<T,ApiError>) -> Void) {
        guard let apiURL = apiURL else {
            completion(.failure(.badURL))
            return
        }
        sessionManager.request(apiURL, method: .get, parameters: parameters)
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
