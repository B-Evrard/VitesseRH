//
//  User.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 24/10/2024.
//


struct User : Decodable {
    let email: String
    let password: String
}

struct Token : Decodable {
    let token: String?
    let isAdmin: Bool
}
