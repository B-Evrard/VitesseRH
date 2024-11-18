//
//  AppViewModel.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 13/11/2024.
//

import Foundation

class AppViewModel: ObservableObject {
    @Published var isLogged: Bool
    
    let tokenManager: TokenManager
    
    init() {
        self.isLogged = false
        self.tokenManager = TokenManager.shared
    }
    
    
}
