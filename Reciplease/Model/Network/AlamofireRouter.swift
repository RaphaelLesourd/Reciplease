//
//  Router.swift
//  Reciplease
//
//  Created by Birkyboy on 22/09/2021.
//

import Foundation
import Alamofire

/// This enum allows to have a centralized endpoints query.
/// Should we need to make other type of queries in the future, new cases will just need to be added.
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
    private var path: String {
        switch self {
        case .ingredients:
            return ""
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
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10*1000)
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
