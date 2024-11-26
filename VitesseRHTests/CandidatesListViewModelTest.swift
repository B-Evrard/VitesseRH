//
//  CandidatesListViewModelTest.swift
//  VitesseRHTests
//
//  Created by Bruno Evrard on 26/11/2024.
//

import XCTest


final class CandidatesListViewModelTest: XCTestCase {
    
    let session = MockUrlSession()
    

    @MainActor
    func testGetListCandidates() async {
        session.data = candidatesListJsonHS.data(using: .utf8)
        let endpoint = Endpoint.candidateList
        session.urlResponse = HTTPURLResponse(url: endpoint.api , statusCode: 200, httpVersion: nil, headerFields: nil)
        let mockApiClient = MockApiClient(session: session)
        
        let viewModel = CandidatesListViewModel(apiService: mockApiClient)
       
        // Invalid Json
        await viewModel.getListCandidates()
        XCTAssertEqual(viewModel.messageAlert,APIError.invalidData().message)
        
        // Valid Json
        session.data = candidatesListJson.data(using: .utf8)
        await viewModel.getListCandidates()
        XCTAssertEqual(viewModel.candidatesFilter.count, 3)
        
        XCTAssertEqual(viewModel.candidatesFilter[0].firstName, "Bernard")
        XCTAssertEqual(viewModel.candidatesFilter[0].lastName, "Dupond")
        XCTAssertEqual(viewModel.candidatesFilter[0].email, "be@myemail.com")
        XCTAssertEqual(viewModel.candidatesFilter[0].phone, "0604012136")
        XCTAssertEqual(viewModel.candidatesFilter[0].id, "20AB56FD-1694-4AB4-BFE9-E55B1E027F8A")
        XCTAssertEqual(viewModel.candidatesFilter[0].linkedinURL, nil)
        XCTAssertEqual(viewModel.candidatesFilter[0].isFavorite, false)
        XCTAssertEqual(viewModel.candidatesFilter[0].note, nil)
        
        XCTAssertEqual(viewModel.candidatesFilter[1].firstName, "Jean")
        XCTAssertEqual(viewModel.candidatesFilter[1].lastName, "Martin")
        XCTAssertEqual(viewModel.candidatesFilter[1].email, "jean.martin@myemail.com")
        XCTAssertEqual(viewModel.candidatesFilter[1].phone, "0611223344")
        XCTAssertEqual(viewModel.candidatesFilter[1].id,"F44E018F-0D0F-4F4F-AA79-4682FFF3C497")
        XCTAssertEqual(viewModel.candidatesFilter[1].linkedinURL, nil)
        XCTAssertEqual(viewModel.candidatesFilter[1].isFavorite, false)
        XCTAssertEqual(viewModel.candidatesFilter[1].note, nil)
        
        XCTAssertEqual(viewModel.candidatesFilter[2].firstName, "Marie")
        XCTAssertEqual(viewModel.candidatesFilter[2].lastName, "Dupuis")
        XCTAssertEqual(viewModel.candidatesFilter[2].email, "marie.dupuis@myemail.com")
        XCTAssertEqual(viewModel.candidatesFilter[2].phone, "0601023456")
        XCTAssertEqual(viewModel.candidatesFilter[2].id, "99093C9F-6417-4D9E-A535-A75EBF6C15C2")
        XCTAssertEqual(viewModel.candidatesFilter[2].linkedinURL, nil)
        XCTAssertEqual(viewModel.candidatesFilter[2].isFavorite, false)
        XCTAssertEqual(viewModel.candidatesFilter[2].note, nil)
        
    }
    
    @MainActor
    func testViewCandidate() {
        var mockNavigation = MockNavigationViewModel()
        
        let mockApiClient = MockApiClient(session: session)
        let viewModel = CandidatesListViewModel(apiService: mockApiClient)
       
        viewModel.viewCandidate(navigation: mockNavigation, candidate: testCandidate)
        XCTAssertTrue(mockNavigation.navigateToCandidateCalled)
        XCTAssertEqual(mockNavigation.passedCandidateID,"20AB56FD-1694-4AB4-BFE9-E55B1E027F8A")
        
        mockNavigation = MockNavigationViewModel()
        viewModel.isEdit = true
        viewModel.viewCandidate(navigation: mockNavigation, candidate: testCandidate)
        XCTAssertFalse(mockNavigation.navigateToCandidateCalled)
        
    }
    
    let candidatesListJsonHS = """
   xxxxxx
   """
    
   let candidatesListJson = """
    [
        {
            "phone": "0604012136",
            "note": null,
            "id": "20AB56FD-1694-4AB4-BFE9-E55B1E027F8A",
            "firstName": "Bernard",
            "linkedinURL": null,
            "isFavorite": false,
            "email": "be@myemail.com",
            "lastName": "Dupond"
        },
        {
            "phone": "0601023456",
            "note": null,
            "id": "99093C9F-6417-4D9E-A535-A75EBF6C15C2",
            "firstName": "Marie",
            "linkedinURL": null,
            "isFavorite": false,
            "email": "marie.dupuis@myemail.com",
            "lastName": "Dupuis"
        },
        {
            "phone": "0611223344",
            "note": null,
            "id": "F44E018F-0D0F-4F4F-AA79-4682FFF3C497",
            "firstName": "Jean",
            "linkedinURL": null,
            "isFavorite": false,
            "email": "jean.martin@myemail.com",
            "lastName": "Martin"
        }
    ]
    """
    
    let testCandidate = Candidate(id: "20AB56FD-1694-4AB4-BFE9-E55B1E027F8A",
                                  isFavorite: false,
                                  email:"be@myemail.com",
                                  note: nil,
                                  linkedinURL: nil,
                                  firstName: "Bernard",
                                  lastName: "Dupond",
                                  phone: "0604012136")
}
