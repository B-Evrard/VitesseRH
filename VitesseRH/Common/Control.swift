//
//  Control.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 21/10/2024.
//

import Foundation

/// Controls the input of the different views of the application
public struct Control  {
    
    
    static func login(login: Login) throws (ControlError) {
        try validateEmail(login.email)
        guard login.password.isNotEmpty else {
            throw ControlError.passwordEmpty()
        }
    }
    
    static func registerUser(registerUser: RegisterUser, confirmedPassword: String) throws (ControlError) {
        guard registerUser.firstName.isNotEmpty else {
            throw ControlError.firstNameEmpty()
        }
        guard registerUser.lastName.isNotEmpty else {
            throw ControlError.lastNameEmpty()
        }
        
        try validateEmail(registerUser.email)
        
        guard registerUser.password.isNotEmpty else {
            throw ControlError.passwordEmpty()
        }
        guard registerUser.password == confirmedPassword else {
            throw ControlError.passwordNotMatch()
        }
    }
    
    static func candidate(candidate: Candidate) throws (ControlError) {
        guard candidate.firstName.isNotEmpty else {
            throw ControlError.firstNameEmpty()
        }
        guard candidate.lastName.isNotEmpty else {
            throw ControlError.lastNameEmpty()
        }
        
        if candidate.email.isNotEmpty {
            try validateEmail(candidate.email)
        }
        
        if let linkedinUrl = candidate.linkedinURL, linkedinUrl.isNotEmpty {
            guard isValidLinkedInURL(linkedinUrl) else {
                throw ControlError.invalidLinkedinUrl()
            }
        }
    }
    
    private static func validateEmail(_ email: String) throws (ControlError) {
        guard email.isNotEmpty else {
            throw ControlError.mailEmpty()
        }
        
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        
        guard emailPredicate.evaluate(with: email) else {
            throw ControlError.invalidFormatMail()
        }
    }
    
    static func isValidLinkedInURL(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString),
              url.scheme == "http" || url.scheme == "https",
              url.host == "www.linkedin.com" else {
            return false
        }
        return true
    }
    
    
}
