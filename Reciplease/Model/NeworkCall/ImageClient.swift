//
//  RecipeImageClient.swift
//  Reciplease
//
//  Created by Birkyboy on 08/09/2021.
//

import Foundation
import Alamofire
import AlamofireImage

class ImageClient {

    let imageDownloader = ImageDownloader(configuration: ImageDownloader.defaultURLSessionConfiguration(),
                                          downloadPrioritization: .fifo,
                                          maximumActiveDownloads: 4,
                                          imageCache: AutoPurgingImageCache())

    func getImage(with providedURL: String?, completion: @escaping (UIImage?) -> Void) {
        guard let stringURL = providedURL,
              let imageURL = URL(string: stringURL) else {
            completion(nil)
            return
        }
        let request = URLRequest(url: imageURL)
        imageDownloader.download(request, completion: { response in
                switch response.result {
                case .success(let image):
                    DispatchQueue.main.async {
                        completion(image)
                    }
                case .failure(_):
                    completion(nil)
                }
        })
    }
}
