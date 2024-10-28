//
//  Candidate.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 24/10/2024.
//


struct Candidate: Decodable {
    let id: String?
    let isFavorite: Bool
    let email: String
    let note: String?
    let linkedinURL: String?
    let firstName: String
    let lastName: String
    let phone: String
}
