//
//  CandidateViewModel.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 01/11/2024.
//

import Foundation
import SwiftUICore

@MainActor
class CandidateViewModel: ObservableObject {
    
    @Published var id: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var linkedIn: String = ""
    @Published var note: String = ""
    @Published var favorite: Bool = false
    
    @Published var isLinkedInURLValid: Bool = false
    @Published var messageAlert: String = ""
    @Published var showMessage: Bool = false
    
    var name: String = ""
    
    @Published var mode: FormMode
    
    private let apiService: APIService
    
    /// View or edit candidate
    /// - Parameters:
    ///   - apiService: apiService
    ///   - id: Candidate Id
    init(apiService: APIService, mode: FormMode, id: String ) {
        self.apiService = apiService
        //self.navigation = navigation
        self.mode = mode
        self.id = id
    }
    
    /// Add candidate
    /// - Parameters:
    ///   - apiService: apiService
    init(apiService: APIService) {
        self.apiService = apiService
        //self.navigation = navigation
        self.mode = FormMode.add
        
    }
    
    func readCandidate() async {
        
        if (self.mode != .add) {
            let id = self.id
            let result = await apiService.candidate(id: id)
            switch result {
                
            case .success(let candidate):
                candidateToView(candidate: candidate)
                return
                
            case .failure(let error):
                messageAlert = error.message
                return
            }
        }
        
    }
    
    func validate() async  {
        // Control
        self.messageAlert = ""
        self.showMessage = false
        let candidate = viewToCandidate()
        do {
            try Control.candidate(candidate: candidate)
        } catch let error {
            messageAlert = error.message
            return
        }
        
        // Update
        var result: Result<Candidate, APIError>?
        switch mode {
        case .edit:
            result = await apiService.updateCandidate(candidate: candidate)
        case .add:
            result = await apiService.createCandidate(candidate: candidate)
        case .view: break
        }
        
        switch result {
            
        case .success:
            self.showMessage = true
            return
            
        case .failure(let error):
            messageAlert = error.message
            return
        case .none:
            break
        }
        
    }
    
    func updateFavorite() async {
        self.messageAlert = ""
        let result = await apiService.updateFavorite(id: self.id)
        switch result {
            
        case .success:
            return
            
        case .failure(let error):
            messageAlert = error.message
            return
            
        }
    }
    
    
    func candidateToView(candidate: Candidate) {
        self.id = candidate.id ?? ""
        self.favorite = candidate.isFavorite
        self.email = candidate.email
        self.note = candidate.note ?? ""
        self.linkedIn = candidate.linkedinURL ?? ""
        self.firstName = candidate.firstName
        self.lastName = candidate.lastName
        self.phone = candidate.phone ?? ""
        
        self.name = candidate.name
        self.isLinkedInURLValid = false
        if linkedIn.isNotEmpty {
            self.isLinkedInURLValid = Control.isValidLinkedInURL(linkedIn)
        }
        
        
        
    }
    
    func viewToCandidate() -> Candidate {
        let candidate = Candidate(id: self.id, isFavorite: self.favorite,
                                  email: self.email, note: self.note,
                                  linkedinURL: self.linkedIn, firstName: self.firstName,
                                  lastName: self.lastName, phone: self.phone)
        
        return candidate
    }
    
    var isEditMode: Bool {
        return (mode == .add ||  mode == .edit) ? true : false
    }
    
    var isAddMode: Bool {
        return mode == .add ? true : false
    }
    
    var isAllowedEditFavorite: Bool {
        guard let token = TokenManager.shared.tokenStorage.token else { return false }
        return !isEditMode && token.isAdmin
    }
    
}


