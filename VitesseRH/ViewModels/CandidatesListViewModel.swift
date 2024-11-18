//
//  CandidatesListViemModel.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 29/10/2024.
//

import Foundation
import SwiftUICore
import SwiftUI

@MainActor
class CandidatesListViewModel: ObservableObject {
    
    private var candidates: [Candidate] = []
    @Published var candidatesFilter: [Candidate] = []
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
    @Published var isEdit: Bool = false
    @Published var search = ""
    
    
    
    private let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func getListCandidates() async {
        
        let result = await apiService.candidateList()
        switch result {
        
        case .success(let candidateList):
            candidates = candidateList
            filterCandidates()
            return
        
        case .failure(let error):
            messageAlert = error.message
            return
        }
    }
    
    func viewCandidate(navigation: NavigationViewModel, candidate: Candidate) {
        guard let candidateID = candidate.id else { return }
        navigation.navigateToCandidate(id: candidateID)
        
    }
    
    func filterCandidates() {
        guard search.isNotEmpty else {
            candidatesFilter = candidates
            return
        }
        candidatesFilter = candidates.filter { candidate in
            candidate.name.contains(self.search)
        }
    }
    
    
    
    
}
