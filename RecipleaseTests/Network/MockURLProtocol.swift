//
//  UrlProtocolMock.swift
//  RecipleaseTests
//
//  Created by Birkyboy on 19/09/2021.
//

import Foundation
import XCTest

class MockURLProtocol: URLProtocol {

    static var error: Error?
    static var data: Data?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let error = MockURLProtocol.error {
            client?.urlProtocol(self, didFailWithError: error)
            client?.urlProtocolDidFinishLoading(self)
            return
        }
        guard let data = MockURLProtocol.data else {
            return
        }
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
