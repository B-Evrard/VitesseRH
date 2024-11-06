//
//  ErrorResponse.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 28/10/2024.
//


struct ErrorResponse: Decodable {
    let error: Bool
    let reason: String
}
