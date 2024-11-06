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
    
    @ObservedObject var navigation: NavigationViewModel
    
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
    
    private let tokenManager: TokenManager
    
    var login: Login?
    
    private let apiService: APIService
    
    init(apiService: APIService, navigation: NavigationViewModel) {
        self.apiService = apiService
        self.navigation = navigation
        self.tokenManager = TokenManager.shared
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
        guard let login = self.login else {
            messageAlert = ControlError.genericError().message
            return
        }
        let result = await apiService.authentication(login: login)
        switch result {
        
        case .success(let token):
            tokenManager.tokenStorage.token = token
            isLogged = true
            navigation.navigateToCandidatesList()
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


