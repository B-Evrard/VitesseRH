//
//  APIError.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 21/10/2024.
//


enum APIError: Error {
    case invalidResponse(message: String = "An error has occurred.")
    case invalidData(message: String = "An error has occurred.")
    case invalidURL(message: String = "An error has occurred.")
    case authenticationFailed(message: String = "Invalid authentication.")
    case unauthorized(message: String = "An error has occurred.")
    case genericError(message: String = "An error has occurred.")
    case userExists(message: String = "This User already exists")
    
    var message: String {
        switch self {
        case .invalidResponse(let message),
                .invalidData(let message),
                .invalidURL(let message),
                .authenticationFailed(let message),
                .unauthorized(let message),
                .genericError(let message),
                .userExists(let message):
            return message
        }
    }
    
    
}
