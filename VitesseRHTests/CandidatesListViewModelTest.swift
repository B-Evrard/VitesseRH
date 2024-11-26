//
//  CandidatesListViewModelTest.swift
//  VitesseRHTests
//
//  Created by Bruno Evrard on 26/11/2024.
//

import XCTest


final class CandidatesListViewModelTest: XCTestCase {
    
    @MainActor
    func getListCandidates() async {
        
        let session = MockUrlSession()
        //session.data = token.data(using: .utf8)
        
        let endpoint = Endpoint.candidateList
        session.urlResponse = HTTPURLResponse(url: endpoint.api , statusCode: 200, httpVersion: nil, headerFields: nil)
        let mockApiClient = MockApiClient(session: session)
        
        let viewModel = CandidatesListViewModel(apiService: mockApiClient)

    }
    
   
}
