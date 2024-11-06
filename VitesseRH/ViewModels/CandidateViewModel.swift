//
//  CandidateViewModel.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 01/11/2024.
//

import Foundation
import SwiftUICore

class CandidateViewModel: ObservableObject {
    
    @Published var candidate: Candidate?
    @ObservedObject var navigation: NavigationViewModel
    
    private let mode: FormMode
    private var id: String?
    private let apiService: APIService
    
    /// View or edit candidate
    /// - Parameters:
    ///   - apiService: apiService
    ///   - id: Candidate Id
    init(apiService: APIService, navigation: NavigationViewModel, id: String ) {
        self.apiService = apiService
        self.navigation = navigation
        self.mode = FormMode.view
        self.id = id
        self.candidate = readCandidate()
       
    }
    
    /// Add candidate
    /// - Parameters:
    ///   - apiService: apiService
    init(apiService: APIService,navigation: NavigationViewModel ) {
        self.apiService = apiService
        self.navigation = navigation
        self.mode = FormMode.add
        self.candidate = Candidate(id: nil, isFavorite: false, email: "", note: nil, linkedinURL: nil, firstName: "", lastName: "", phone: nil)
    }
    
    func readCandidate() -> Candidate {
        
        return Candidate(id: nil, isFavorite: false, email: "", note: nil, linkedinURL: nil, firstName: "", lastName: "", phone: nil)
        
        
    }
    
    func Validate()  {
        
        
    }
                       
                     
        
    
    
}


