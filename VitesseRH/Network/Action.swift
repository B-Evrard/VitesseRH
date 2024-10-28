//
//  Action.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 21/10/2024.
//

import Foundation

enum Action  {
    case user_auth (login: Login)
    case user_register (registerUser: RegisterUser)
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    struct ErrorResponse: Decodable {
        let error: Bool
        let reason: String
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .user_auth: return .POST
        case .user_register: return .POST
        }
    }

    var baseURL: URL {
            URL(string: "http://127.0.0.1:8080")!
        }
    
    var api: URL {
        switch self {
        case .user_auth: return baseURL.appendingPathComponent(
            "user/auth"
        )
        case .user_register: return baseURL.appendingPathComponent(
            "user/register"
        )
        
        }
    }
    
    var body: Data? {
        switch self {
        case .user_auth(login: let login):
            return try? JSONEncoder().encode(login)
        case .user_register(registerUser: let registerUser):
            return try? JSONEncoder().encode(registerUser)
        }
    }
    
    func response <T: Decodable>(data: Data, response: HTTPURLResponse) -> Result<T, APIError> {
        switch response.statusCode {
        case 200...201:
            return successResponse(data: data)
        case 400...499:
            guard let error = try? JSONDecoder().decode(ErrorResponse.self, from: data) else {
                   return .failure(APIError.genericError())
            }
            return  .failure(APIError.invalidResponse(message: error.reason))
        case 500:
            guard let error = try? JSONDecoder().decode(ErrorResponse.self, from: data) else {
                   return .failure(APIError.genericError())
            }
            switch self {
                case .user_register:
                return .failure(APIError.userExists())
            default :
                return .failure(APIError.invalidResponse(message: error.reason))
            }
            
        default:
            return .failure(APIError.genericError(message: "Unknown error"))
        }
        
    }
    
    func successResponse<T: Decodable>(data: Data) -> Result<T, APIError> {
        switch self {
        case .user_auth(_):
            return decodeResponseAuth(data: data)
            
        case .user_register:
            guard let isCreated = true as? T else {
                return .failure(APIError.genericError())
            }
            return .success(isCreated)
        }
    }
    
    private func decodeResponseAuth<T: Decodable>(data: Data) -> Result<T, APIError> {
        
        guard let token = try? JSONDecoder().decode(Token.self, from: data) else {
            return .failure(APIError.invalidData())
        }
        
        guard let token = token as? T else {
            return .failure(APIError.genericError())
        }
        
        return .success(token)
    }
    
    
    
}
