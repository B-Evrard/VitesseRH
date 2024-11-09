//
//  CandidateViewModel.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 01/11/2024.
//

import Foundation
import SwiftUICore

class CandidateViewModel: ObservableObject {
    
    @ObservedObject var navigation: NavigationViewModel
    
    @Published var id: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var linkedIn: String = ""
    @Published var note: String = ""
    @Published var favorite: Bool = false
        
    @Published var messageAlert: String = ""
    @Published var showMessage: Bool = false
    
    private let mode: FormMode
    private let apiService: APIService
    
    /// View or edit candidate
    /// - Parameters:
    ///   - apiService: apiService
    ///   - id: Candidate Id
    init(apiService: APIService, navigation: NavigationViewModel, id: String ) async {
        self.apiService = apiService
        self.navigation = navigation
        self.mode = FormMode.view
        self.id = id
        await readCandidate()
       
    }
    
    /// Add candidate
    /// - Parameters:
    ///   - apiService: apiService
    init(apiService: APIService,navigation: NavigationViewModel ) {
        self.apiService = apiService
        self.navigation = navigation
        self.mode = FormMode.add
        let candidate = Candidate(id: nil, isFavorite: false, email: "", note: nil, linkedinURL: nil, firstName: "", lastName: "", phone: nil)
    }
    
    func readCandidate() async {
        
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
    
    func validate() async  {
        // Control
        self.messageAlert = ""
        self.showMessage = false
        let candidate = viewToCandidate()
        do {
            try Control().candidate(candidate: <#T##Candidate#>)
        } catch let error {
           
        }
        
        // Create candidate
        let result = await apiService.candidate(id: <#T##String#>)
        switch result {
        
        case .success:
            self.showMessage = true
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
    }
    
    func viewToCandidate() -> Candidate {
        let candidate = Candidate(id: self.id, isFavorite: self.favorite,
                                  email: self.email, note: self.note,
                                  linkedinURL: self.linkedIn, firstName: self.firstName,
                                  lastName: self.lastName, phone: self.phone)
        
        return candidate
    }
                     
        
    
    
}


