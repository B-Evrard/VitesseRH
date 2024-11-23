//
//  MockUrlSession.swift
//  VitesseRHTests
//
//  Created by Bruno Evrard on 22/11/2024.
//

import Foundation

import Foundation


class MockUrlSession: URLSessionProtocol {
    
    var data: Data?
    var urlResponse: URLResponse?
    var error: Error?
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        guard let data = data, let urlResponse = urlResponse else {
            throw APIError.invalidData()
        }
        return (data, urlResponse)
    }
}
