//
//  RegisterViewModels.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 21/10/2024.
//

import Foundation

@MainActor
class RegisterViewModel: ObservableObject {
    
    @Published var registerUser = RegisterUser(email: "", password: "", firstName: "", lastName: "" )
    @Published var confirmedPassword  = ""
    
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
    @Published var showMessage: Bool = false
    
    private let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func register() async {
        // Control
        do {
            try Control().registerUser(registerUser: registerUser, confirmedPassword: confirmedPassword)
        } catch let error {
            messageAlert = error.message
            return
        }
        
        //Create registeredUser
        do {
            if  try await apiService.userRegister(registerUser: registerUser)
            {
                self.showMessage = true
                
            }
        } catch let error {
            messageAlert = error.message
            return
        }
    }
    
    func raz() {
        self.showMessage = false
        self.messageAlert = ""
        self.confirmedPassword = ""
        registerUser = RegisterUser(email: "", password: "", firstName: "", lastName: "" )
    }
    
}
