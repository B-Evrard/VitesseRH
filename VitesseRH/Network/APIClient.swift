//
//  APIClient.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 21/10/2024.
//

import Foundation

final class APIClient: APIService {
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    var apiClientCore: APIClientCore {
        APIClientCore(session: session)
    }
    
    func authentication(login: Login) async throws (APIError) -> Token {
        let token: Token = try await apiClientCore.performAPIRequest(action: Action.user_auth(login: login)).get()
        return token
    }
    
    func userRegister(registerUser: RegisterUser) async throws(APIError) -> Bool {
        let resultat: Bool = try await apiClientCore.performAPIRequest(action: Action.user_register(registerUser: registerUser)).get()
        return resultat
    }
    
    
}
    
