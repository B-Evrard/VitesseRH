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
    
    private let apiService: APIService
    private var candidates: [Candidate] = []
    @Published var candidatesFilter: [Candidate] = []
    @Published var candidatesSelected: [Candidate] = []
    @Published var messageAlert: String = ""
    
    @Published var isEdit: Bool = false
    @Published var isFilterFav: Bool = false
    @Published var search = ""
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func getListCandidates() async {
        self.messageAlert = ""
        let result = await apiService.candidateList()
        switch result {
        case .success(let candidateList):
            candidates = candidateList
            filterAndSortCandidates()
            return
            
        case .failure(let error):
            messageAlert = error.message
            return
        }
    }
    
    func viewCandidate(navigation: NavigationViewModel, candidate: Candidate) {
        if !self.isEdit {
            guard let candidateID = candidate.id else { return }
            navigation.navigateToCandidate(id: candidateID)
        }
    }
    
    func filterAndSortCandidates() {
        if search.isNotEmpty {
            candidatesFilter = candidates.filter { candidate in
                candidate.name.contains(self.search)  && (isFilterFav ? candidate.isFavorite : true)
            }.sorted { $0.name < $1.name }
        } else {
            candidatesFilter = candidates.filter { candidate in
                (isFilterFav ? candidate.isFavorite : true)
            }.sorted { $0.name < $1.name}
        }
    }
    
    func switchEditOrViewMode() {
        self.isEdit.toggle()
    }
    
    func deleteCandidates() async {
        self.messageAlert = ""
        var candidatesDelete: [Candidate] = []
        for candidate in candidatesFilter.filter({ $0.isSelected }) {
            let result = await apiService.deleteCandidate(id: candidate.id!)
            
            switch result {
                
            case .success:
                candidatesDelete.append(candidate)
            case .failure(_):
                self.messageAlert = "An error has occurred"
            }
        }
        if !candidatesDelete.isEmpty {
            candidatesFilter.removeAll { candidate in
                candidatesDelete.contains { $0.id == candidate.id }
            }
        }
    }
    
}
