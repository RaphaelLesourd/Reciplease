//
//  Router.swift
//  Reciplease
//
//  Created by Birkyboy on 22/09/2021.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    
    enum Constants {
        static let baseURLPath = "https://api.edamam.com/api/recipes/v2"
    }
    
    case ingredients([String])
    
    var method: HTTPMethod {
        switch self {
        case .ingredients:
            return .get
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .ingredients(let ingredientList):
            return ["q": ingredientList.joined(separator: ","),
                    "type": "public",
                    "app_id": ApiKey.appID,
                    "app_key": ApiKey.appKey]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseURLPath.asURL()
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10*1000)
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
