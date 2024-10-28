//
//  Control.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 21/10/2024.
//

import Foundation

/// Controls the input of the different views of the application
public struct Control  {
    
    
    func login(login: Login) throws (ControlError) {
        try validateEmail(login.email)
        if login.password.isEmpty {
            throw ControlError.passwordEmpty()
        }
    }
    
    func registerUser(registerUser: RegisterUser, confirmedPassword: String) throws (ControlError) {
        if registerUser.firstName.isEmpty {
            throw ControlError.firstNameEmpty()
        }
        if registerUser.lastName.isEmpty {
            throw ControlError.lastNameEmpty()
        }
        try validateEmail(registerUser.email)
        if registerUser.password.isEmpty {
            throw ControlError.passwordEmpty()
        }
        if (registerUser.password != confirmedPassword) {
            throw ControlError.passwordNotMatch()
        }
        
      }
    
    

    
    
    private func validateEmail(_ email: String) throws (ControlError) {
        if email.isEmpty {
            throw ControlError.mailEmpty()
        }
        
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        
        if !emailPredicate.evaluate(with: email) {
            throw ControlError.invalidFormatMail()
        }
    }
    
}
