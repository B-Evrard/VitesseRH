//
//  CandidatesListViemModel.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 29/10/2024.
//

import Foundation
import SwiftUICore

@MainActor
class CandidatesListViewModel: ObservableObject {
    
    @ObservedObject var navigation: NavigationViewModel
    @Published var candidates: [Candidate] = []
    @Published var messageAlert: String = "" {
        didSet {
            if messageAlert.isEmpty {
                showAlert = false
            }
            else {
                showAlert = true
            }
        }
    }
    @Published var showAlert: Bool = false
    @Published var addCandidate: Bool = false
    
    private let apiService: APIService
    
    init(apiService: APIService, navigation: NavigationViewModel) {
        self.apiService = apiService
        self.navigation = navigation
    }
    
    func getListCandidates() async {
        
        let result = await apiService.candidateList()
        switch result {
        
        case .success(let candidateList):
            candidates = candidateList
            return
        
        case .failure(let error):
            messageAlert = error.message
            return
        }
        
            
    }
    
    
}
