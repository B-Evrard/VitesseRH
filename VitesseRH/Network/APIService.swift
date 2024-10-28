//
//  APIService.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 21/10/2024.
//

import Foundation

protocol APIService {
    
    func authentication(login: Login) async throws (APIError) -> Token
    
    func userRegister(registerUser: RegisterUser) async throws (APIError) -> Bool
}
