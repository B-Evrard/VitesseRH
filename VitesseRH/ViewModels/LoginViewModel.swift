//
//  LoginViewModel.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 21/10/2024.
//

import Foundation
import SwiftUICore

@MainActor
class LoginViewModel: ObservableObject {
    
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
    
    let onLoginSucceed: ((Token) -> Void)
    
    private var login: Login?
    private let apiService: APIService
    
    init(apiService: APIService, _ callback: @escaping (Token) -> Void) {
        self.apiService = apiService
        self.onLoginSucceed = callback
    }
    
    func authenticate() async {
        self.messageAlert = ""
        self.login = Login(email: email, password: password)
        
        // Control
        do {
            guard let login = login else {
                messageAlert = ControlError.genericError().message
                return
            }
            try Control.login(login: login)
        } catch let error {
            messageAlert = error.message
            return
        }
        
        // Auth
        guard let login = self.login else {
            messageAlert = ControlError.genericError().message
            return
        }
        let result = await apiService.authentication(login: login)
        switch result {
            
        case .success(let token):
            onLoginSucceed(token)
            return
            
        case .failure(let error):
            messageAlert = error.message
        }
    }
    
    func raz() {
        email = ""
        password = ""
        messageAlert = ""
    }
    
}


