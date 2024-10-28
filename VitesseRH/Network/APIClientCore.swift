//
//  APIClientCore.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 21/10/2024.
//

import Foundation

final class APIClientCore {
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func performAPIRequest <T: Decodable> (action: Action) async -> Result<T, APIError> {
        
        let url = action.api
        var request : URLRequest?
        request = URLRequest(url: url)
        request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
              
        request?.httpBody = action.body
        request?.httpMethod = action.httpMethod.rawValue
        
        do {
            guard let request else {
                return .failure(.genericError())
            }
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.genericError())
            }
            
            return action.response(data: data, response: httpResponse)
            
            
        } catch let apiError as APIError {
            return .failure(apiError)
        } catch {
            return .failure(.genericError())
        }
    }
    
}
