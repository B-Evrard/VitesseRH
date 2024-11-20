//
//  Endpoint.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 21/10/2024.
//

import Foundation

enum Endpoint  {
    case user_auth (login: Login)
    case user_register (registerUser: RegisterUser)
    case candidateList
    case candidate (id: String)
    case updateCandidate (candidate: Candidate)
    case createCandidate (candidate: Candidate)
    case deleteCandidate (id: String)
    case updateFavorite (id: String)
    
    enum HTTPMethod: String {
        case GET
        case POST
        case PUT
        case DELETE
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .user_auth: return .POST
        case .user_register: return .POST
        case .candidateList: return .GET
        case .candidate: return .GET
        case .createCandidate: return .POST
        case .updateCandidate: return .PUT
        case .deleteCandidate: return .DELETE
        case .updateFavorite: return .POST
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
        case .candidateList: return baseURL.appendingPathComponent("candidate")
        case .candidate(let id): return baseURL.appendingPathComponent("candidate/\(id)")
        case .createCandidate: return baseURL.appendingPathComponent("candidate")
        case .updateCandidate(let candidate):
            if let id = candidate.id {
                return baseURL.appendingPathComponent("candidate/\(id)")
            } else {
                return baseURL.appendingPathComponent("candidate/")
            }
        case .deleteCandidate(let id): return baseURL.appendingPathComponent("candidate/\(id)")
            
        case .updateFavorite(id: let id):
            return baseURL.appendingPathComponent("candidate/\(id)/favorite")
        }
    }
    
    var body: Data? {
        switch self {
        case .user_auth(login: let login):
            return try? JSONEncoder().encode(login)
        case .user_register(registerUser: let registerUser):
            return try? JSONEncoder().encode(registerUser)
        case .updateCandidate(candidate: let candidate), .createCandidate(candidate: let candidate):
            return try? JSONEncoder().encode(candidate)
            
        default : return nil
        }
    }
    
    
    
    
    
    
    
}
