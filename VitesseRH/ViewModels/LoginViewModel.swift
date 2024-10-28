//
//  LoginViewModel.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 21/10/2024.
//

import Foundation

class AuthenticationViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var messageAlert: String = "" {
        didSet {
            if messageAlert.isEmpty {
                showAlert = false
            }
            else {
                showAlert = true
            }
        }
    }
    @Published var showAlert: Bool = false
    
    @Published var user: User?
    
    private func authenticate() {
        
        user = User(email: email, password: password)
        do {
            guard let user else { return }
            try Control().login(user: user)
        } catch let error {
            messageAlert = error.message
            return
        }
        
    }
    
    
}


