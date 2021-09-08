//
//  RecipeService.swift
//  Reciplease
//
//  Created by Birkyboy on 06/09/2021.
//

import Foundation
import Alamofire

class ApiClient {

    func getData<T: Decodable>(with apiURL: URL?, completion: @escaping (Result<T,ApiError>) -> Void) {

        guard let apiURL = apiURL else {
            completion(.failure(.badURL))
            return
        }
        AF.request(apiURL, method: .get).responseJSON { response in
            guard let itemsData = response.data else {
                completion(.failure(.responseError))
                return
            }
            do {
                let decoder = JSONDecoder()
                let items = try decoder.decode(T.self, from: itemsData)
                DispatchQueue.main.async {
                    completion(.success(items))
                }
            } catch {
                completion(.failure(.decodeError))
            }
        }
    }
}
