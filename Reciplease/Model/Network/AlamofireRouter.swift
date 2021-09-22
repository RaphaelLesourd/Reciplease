//
//  Router.swift
//  Reciplease
//
//  Created by Birkyboy on 22/09/2021.
//

import Foundation
import Alamofire

enum AlamofireRouter: URLRequestConvertible {
    // cases
    case ingredients([String])
    // Http methods
    private var method: HTTPMethod {
        switch self {
        case .ingredients:
            return .get
        }
    }
    // Parameters
    private var parameters: [String: Any] {
        switch self {
        case .ingredients(let ingredientList):
            return ["q": ingredientList.joined(separator: ","),
                    "type": "public",
                    "app_id": ApiKey.appID,
                    "app_key": ApiKey.appKey]
        }
    }
    // Conforming to URLRequestConvertible protocol, returning URLRequest
    func asURLRequest() throws -> URLRequest {
        let url = try ApiURL.baseURLPath.asURL()
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10*1000)
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
