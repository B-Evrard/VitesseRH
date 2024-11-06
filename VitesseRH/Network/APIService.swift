//
//  APIService.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 21/10/2024.
//

import Foundation

protocol APIService {
    
    func authentication(login: Login) async -> Result<Token, APIError>
    
    func userRegister(registerUser: RegisterUser) async  -> Result<Bool, APIError>
    
    func candidateList() async -> Result<[Candidate],APIError>
    
    func candidate(id: String) async -> Result<Candidate,APIError>
}
