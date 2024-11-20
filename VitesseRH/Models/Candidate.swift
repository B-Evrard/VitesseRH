//
//  Candidate.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 24/10/2024.
//


struct Candidate: Codable {
    let id: String?
    let isFavorite: Bool
    let email: String
    let note: String?
    let linkedinURL: String?
    var firstName: String
    var lastName: String
    let phone: String?
    
    var name: String {
        return "\(firstName) \(lastName)"
    }
    
    var isSelected: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case isFavorite
        case email
        case note
        case linkedinURL
        case firstName
        case lastName
        case phone
    }
}
