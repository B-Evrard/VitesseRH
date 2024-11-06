//
//  TokenStorage.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 29/10/2024.
//

import Foundation

class TokenManager {
    static let shared = TokenManager()
    let tokenStorage = TokenStorage()
    
    private init() {}
}

class TokenStorage {
    var token: Token?
}
