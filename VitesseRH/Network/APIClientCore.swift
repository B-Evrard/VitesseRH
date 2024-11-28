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
    
    func performAPIRequest <T: Decodable> (endPoint: Endpoint) async -> Result<T, APIError> {
        
        let url = endPoint.api
        var request : URLRequest?
        request = URLRequest(url: url)
        request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let data = endPoint.body
        if let data {
            request?.httpBody = data
        }
        
        // TODO: Supprimer le test preview
        if let token = TokenManager.shared.tokenStorage.token {
            let authorizationHeader = "Bearer \(token.token ?? "")"
            request?.addValue(authorizationHeader, forHTTPHeaderField: "Authorization")
        }
        
        request?.httpMethod = endPoint.httpMethod.rawValue
        
        do {
            guard let request else {
                return .failure(.genericError())
            }
            let (data, response) = try await session.data(for: request)
           
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.genericError())
            }
            
            return performResponse(endPoint: endPoint, data: data, httpResponse: httpResponse)
            
            
        } catch let apiError as APIError {
            return .failure(apiError)
        } catch {
            return .failure(.genericError())
        }
    }
    
    
    func performResponse <T: Decodable> (endPoint: Endpoint, data: Data, httpResponse: HTTPURLResponse)  -> Result<T, APIError> {
        
        switch httpResponse.statusCode {
        case 200...299:
            
            if data.isEmpty {
                return .success(true as! T)
            }
            guard let result = try? JSONDecoder().decode(T.self, from: data) else {
                return .failure(APIError.invalidData())
            }
            return .success(result)
            
        case 400...499:
            guard let error = try? JSONDecoder().decode(ErrorResponse.self, from: data) else {
                return .failure(APIError.genericError())
            }
            return  .failure(APIError.invalidResponse(message: error.reason))
        case 500:
            guard let error = try? JSONDecoder().decode(ErrorResponse.self, from: data) else {
                return .failure(APIError.genericError())
            }
            switch endPoint {
            case .user_register:
                return .failure(APIError.userExists())
            default :
                return .failure(APIError.invalidResponse(message: error.reason))
            }
            
        default:
            return .failure(APIError.genericError(message: "Unknown error"))
        }
        
    }
    
}
