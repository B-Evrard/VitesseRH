//
//  CandidateViewModelTest.swift
//  VitesseRHTests
//
//  Created by Bruno Evrard on 26/11/2024.
//

import XCTest

final class CandidateViewModelTest: XCTestCase {

    let session = MockUrlSession()
    
    @MainActor
    func testReadCandidate() async  {
        session.data = candidateTest.data(using: .utf8)
        let endpoint = Endpoint.candidate(id: "20AB56FD-1694-4AB4-BFE9-E55B1E027F8A")
        session.urlResponse = HTTPURLResponse(url: endpoint.api , statusCode: 200, httpVersion: nil, headerFields: nil)
        let mockApiClient = MockApiClient(session: session)
        
        let viewModel = CandidateViewModel(apiService: mockApiClient, mode: FormMode.view, id: "20AB56FD-1694-4AB4-BFE9-E55B1E027F8A")
        await viewModel.readCandidate()
        XCTAssertEqual(viewModel.firstName, "Bernard")
        XCTAssertEqual(viewModel.lastName, "Dupond")
        XCTAssertEqual(viewModel.email, "be@myemail.com")
        XCTAssertEqual(viewModel.phone, "0604012136")
        XCTAssertEqual(viewModel.id, "20AB56FD-1694-4AB4-BFE9-E55B1E027F8A")
        XCTAssertFalse(viewModel.favorite)
        
        
    }
    
    let candidateTest = """
        {
            "phone": "0604012136",
            "note": null,
            "id": "20AB56FD-1694-4AB4-BFE9-E55B1E027F8A",
            "firstName": "Bernard",
            "linkedinURL": null,
            "isFavorite": false,
            "email": "be@myemail.com",
            "lastName": "Dupond"
        }
    """

}
