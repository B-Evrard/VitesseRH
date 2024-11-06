//
//  RegisterViewModels.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 21/10/2024.
//

import Foundation
import SwiftUICore

@MainActor
class RegisterViewModel: ObservableObject {
    
    @ObservedObject var navigation: NavigationViewModel
    
    @Published var registerUser = RegisterUser(email: "", password: "", firstName: "", lastName: "" )
    @Published var confirmedPassword  = ""
    
    @Published var messageAlert: String = ""
    @Published var showMessage: Bool = false
    
    private let apiService: APIService
    
    init(apiService: APIService, navigation: NavigationViewModel) {
        self.apiService = apiService
        self.navigation = navigation
    }
    
    func register() async {
        // Control
        self.messageAlert = ""
        do {
            try Control().registerUser(registerUser: registerUser, confirmedPassword: confirmedPassword)
        } catch let error {
            messageAlert = error.message
            return
        }
        
        // Create registeredUser
        let result = await apiService.userRegister(registerUser: registerUser)
        switch result {
        
        case .success:
            self.showMessage = true
            return
            
        case .failure(let error):
            messageAlert = error.message
            return
        }
      
    }
    
    func cancel(){
        navigation.goBack()
    }
    
    func raz() {
        self.showMessage = false
        self.messageAlert = ""
        self.confirmedPassword = ""
        registerUser = RegisterUser(email: "", password: "", firstName: "", lastName: "" )
    }
    
}
