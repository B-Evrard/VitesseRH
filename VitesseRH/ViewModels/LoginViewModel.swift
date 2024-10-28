//
//  LoginViewModel.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 21/10/2024.
//

import Foundation

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
    
    @Published var isLogged: Bool = false
    
    var login: Login?
    var token: Token?
    
    
    private let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
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
            try Control().login(login: login)
        } catch let error {
            messageAlert = error.message
            return
        }
        
        // Auth
        do {
            guard let login = self.login else {
                messageAlert = ControlError.genericError().message
                return
            }
            try await token = apiService.authentication(login: login)
            isLogged = true
        } catch let error {
            messageAlert = error.message
            return
        }
        
        
        
    }
    
    
}


