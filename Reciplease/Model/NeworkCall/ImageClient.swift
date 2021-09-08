//
//  RecipeImageClient.swift
//  Reciplease
//
//  Created by Birkyboy on 08/09/2021.
//

import Foundation
import Alamofire

class ImageClient {

    let alamoFireManager = Session(configuration: .default,
                                   delegate: SessionDelegate(),
                                   startRequestsImmediately: true)
    var count = 0

    func getImage(with providedURL: String?, completion: @escaping (Result<UIImage, ApiError>) -> Void) {
        guard let stringURL = providedURL,
              let imageURL = URL(string: stringURL) else {
            completion(.failure(.badURL))
            return
        }
        count += 1
        print("Called \(count) times")
        alamoFireManager.download(imageURL).validate().responseData { response in
            DispatchQueue.main.async {
                switch response.result {
                case .success(let responseData):
                        guard let image = UIImage(data: responseData, scale: 1) else {return}
                        completion(.success(image))
                case .failure(_):
                        completion(.failure(.noData))
                }
            }
        }
    }
}
