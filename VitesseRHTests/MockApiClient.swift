//
//  MockApiClient.swift
//  VitesseRHTests
//
//  Created by Bruno Evrard on 22/11/2024.
//

import Foundation

final class MockApiClient: APIService {
    
    var session: MockUrlSession
    var apiClientCore: APIClientCore {
        APIClientCore(session: session)
    }
    
    init(session: MockUrlSession) {
        self.session = session
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
        return await apiClientCore.performAPIRequest(endPoint: Endpoint.candidate(id: id))
    }
    
    func createCandidate(candidate: Candidate) async  -> Result<Candidate, APIError> {
        return await apiClientCore.performAPIRequest(endPoint: Endpoint.createCandidate(candidate: candidate))
    }
    
    func updateCandidate(candidate: Candidate) async  -> Result<Candidate, APIError> {
        return await apiClientCore.performAPIRequest(endPoint: Endpoint.updateCandidate(candidate: candidate))
    }
    
    func deleteCandidate(id: String) async -> Result<Bool, APIError> {
        return await apiClientCore.performAPIRequest(endPoint: Endpoint.deleteCandidate(id: id))
    }
    
    func updateFavorite(id: String) async -> Result<Candidate, APIError> {
        return await apiClientCore.performAPIRequest(endPoint: Endpoint.updateFavorite(id: id))
    }
}
