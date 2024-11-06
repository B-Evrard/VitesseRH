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
    
    func authentication(login: Login) async  -> Result<Token, APIError> {
        return await apiClientCore.performAPIRequest(endPoint: Endpoint.user_auth(login: login))
    }
    
    func userRegister(registerUser: RegisterUser) async  -> Result<Bool, APIError> {
        return await apiClientCore.performAPIRequest(endPoint: Endpoint.user_register(registerUser: registerUser))
    }
    
    func candidateList() async  -> Result<[Candidate], APIError> {
        return await apiClientCore.performAPIRequest(endPoint: Endpoint.candidateList)
    }
    
    func candidate(id: String) async  -> Result<Candidate, APIError> {
        return await apiClientCore.performAPIRequest(endPoint: Endpoint.candidate)
    }
    
    
}
    