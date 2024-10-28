//
//  ControlError.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 21/10/2024.
//

import Foundation

enum ControlError: Error {
    case mailEmpty(message: String = "Please enter an email address.")
    case invalidFormatMail(
        message: String = "Please enter a valid email address.")
    case passwordEmpty(message: String = "Please enter your password.")
    case passwordNotMatch(message: String = "Passwords do not match.")
    case firstNameEmpty(message: String = "Please enter your first name.")
    case lastNameEmpty(message: String = "Please enter your name.")
    
    case genericError(message: String = "An error has occurred.")
    
    var message: String {
        switch self {
        case .mailEmpty(let message),
                .invalidFormatMail(let message),
                .passwordEmpty(let message),
                .genericError(let message),
                .firstNameEmpty(let message),
                .passwordNotMatch(let message),
                .lastNameEmpty(let message):
            return message
        }
    }
    
}


