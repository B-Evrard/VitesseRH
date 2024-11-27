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
        
        // Candidate not exist
        session.data = error404.data(using: .utf8)
        session.urlResponse = HTTPURLResponse(url: endpoint.api , statusCode: 404, httpVersion: nil, headerFields: nil)
        await viewModel.readCandidate()
        XCTAssertEqual(viewModel.messageAlert, "Not found.")
    }
    
    @MainActor
    func testAddCandidate() async {
        
        // To be able to use the Endpoint createCandidate in the HTTPURLResponse, we instantiate a candidate
        let candidateTemp = Candidate(id: "", isFavorite: false, email: "", note: "", linkedinURL: nil,  firstName: "", lastName: "", phone: "")
        let endpoint = Endpoint.createCandidate(candidate: candidateTemp)
        session.urlResponse = HTTPURLResponse(url: endpoint.api , statusCode: 200, httpVersion: nil, headerFields: nil)
        let mockApiClient = MockApiClient(session: session)
        
        let viewModel = CandidateViewModel(apiService: mockApiClient)
        
        viewModel.firstName = ""
        viewModel.lastName = ""
        viewModel.email = ""
        viewModel.phone = ""
        viewModel.linkedIn = ""
        viewModel.note = ""
        viewModel.favorite = false
        
        // Empty firstname
        await viewModel.validate()
        XCTAssertEqual(viewModel.messageAlert, ControlError.firstNameEmpty().message)
        
        // Empty lastname
        viewModel.firstName = "Laure"
        await viewModel.validate()
        XCTAssertEqual(viewModel.messageAlert, ControlError.lastNameEmpty().message)
        
        // invalid email
        viewModel.lastName = "Hévia"
        viewModel.email = "lhevia&test.fr"
        await viewModel.validate()
        XCTAssertEqual(viewModel.messageAlert, ControlError.invalidFormatMail().message)
        
        // Add Ok
        session.data = addCandidateTest.data(using: .utf8)
        viewModel.email = "lhevia@test.fr"
        await viewModel.validate()
        XCTAssertTrue(viewModel.showMessage)
        
        
    }
    
    @MainActor
    func testUpdate() async {
        
        // Read candidate
        session.data = candidateTest.data(using: .utf8)
        var endpoint = Endpoint.candidate(id: "20AB56FD-1694-4AB4-BFE9-E55B1E027F8A")
        session.urlResponse = HTTPURLResponse(url: endpoint.api , statusCode: 200, httpVersion: nil, headerFields: nil)
        let mockApiClient = MockApiClient(session: session)
        
        let viewModel = CandidateViewModel(apiService: mockApiClient, mode: FormMode.edit, id: "20AB56FD-1694-4AB4-BFE9-E55B1E027F8A")
        await viewModel.readCandidate()
        
        // Update candidate
        endpoint = Endpoint.updateCandidate(candidate: viewModel.viewToCandidate())
        session.urlResponse = HTTPURLResponse(url: endpoint.api , statusCode: 200, httpVersion: nil, headerFields: nil)
        
        // update Ok
        session.data = addCandidateTest.data(using: .utf8)
        viewModel.email = "newbe@myemail.com"
        await viewModel.validate()
        XCTAssertTrue(viewModel.showMessage)
        
        // update NOK
        session.data = error404.data(using: .utf8)
        session.urlResponse = HTTPURLResponse(url: endpoint.api , statusCode: 404, httpVersion: nil, headerFields: nil)
        await viewModel.validate()
        XCTAssertEqual(viewModel.messageAlert, "Not found.")
        
    }
    
    @MainActor
    func testUpdateFavorite() async {
        
        // Read candidate
        session.data = candidateTest.data(using: .utf8)
        var endpoint = Endpoint.candidate(id: "20AB56FD-1694-4AB4-BFE9-E55B1E027F8A")
        session.urlResponse = HTTPURLResponse(url: endpoint.api , statusCode: 200, httpVersion: nil, headerFields: nil)
        let mockApiClient = MockApiClient(session: session)
        let viewModel = CandidateViewModel(apiService: mockApiClient, mode: FormMode.view, id: "20AB56FD-1694-4AB4-BFE9-E55B1E027F8A")
        await viewModel.readCandidate()
        
        viewModel.favorite.toggle()
        // Update Favorite
        session.data = candidateTestUpdateFavorite.data(using: .utf8)
        endpoint = Endpoint.updateFavorite(id: "20AB56FD-1694-4AB4-BFE9-E55B1E027F8A")
        session.urlResponse = HTTPURLResponse(url: endpoint.api , statusCode: 200, httpVersion: nil, headerFields: nil)
        await viewModel.updateFavorite()
        XCTAssertTrue(viewModel.messageAlert.isEmpty)
        
        // update Favorite NOK
        session.data = error404.data(using: .utf8)
        session.urlResponse = HTTPURLResponse(url: endpoint.api , statusCode: 404, httpVersion: nil, headerFields: nil)
        await viewModel.updateFavorite()
        XCTAssertEqual(viewModel.messageAlert, "Not found.")
    }
    
    @MainActor
    func testIsAllowedEditFavorite() {
        
        session.data = candidateTest.data(using: .utf8)
        let endpoint = Endpoint.candidate(id: "20AB56FD-1694-4AB4-BFE9-E55B1E027F8A")
        session.urlResponse = HTTPURLResponse(url: endpoint.api , statusCode: 200, httpVersion: nil, headerFields: nil)
        let mockApiClient = MockApiClient(session: session)
        
        let viewModel = CandidateViewModel(apiService: mockApiClient, mode: FormMode.view, id: "20AB56FD-1694-4AB4-BFE9-E55B1E027F8A")
        
        TokenManager.shared.tokenStorage.token = token
        XCTAssertFalse(viewModel.isAllowedEditFavorite)
        
        TokenManager.shared.tokenStorage.token = tokenAdmin
        XCTAssertTrue(viewModel.isAllowedEditFavorite)
        
        
    }
    
  
        
    let candidateTest = """
        {
            "phone": "0604012136",
            "note": null,
            "id": "20AB56FD-1694-4AB4-BFE9-E55B1E027F8A",
            "firstName": "Bernard",
            "linkedinURL": "https://www.linkedin.com/in/bruno-evrard-b07850246/",
            "isFavorite": false,
            "email": "be@myemail.com",
            "lastName": "Dupond"
        }
    """
    
    let candidateTestUpdateFavorite = """
        {
            "phone": "0604012136",
            "note": null,
            "id": "20AB56FD-1694-4AB4-BFE9-E55B1E027F8A",
            "firstName": "Bernard",
            "linkedinURL": null,
            "isFavorite": true,
            "email": "be@myemail.com",
            "lastName": "Dupond"
        }
    """
    
    let addCandidateTest = """
        {
            "phone": "",
            "note": null,
            "id": "20AB56FD-1694-4AB4-BFE9-E55B1E027F8A",
            "firstName": "Laure",
            "linkedinURL": null,
            "isFavorite": false,
            "email": "lhevia&test.fr",
            "lastName": "Hévia"
        }
    """
    
    let error404 = """
    {
    "reason":"Not found.",
    "error":true
    }
    """

    let token = Token(token: "FfdfsdfdF9fdsf.fdsfdf98FDkzfdA3122.J83TqjxRzmuDuruBChNT8sMg5tfRi5iQ6tUlqJb3M9U", isAdmin: false)
    let tokenAdmin = Token(token: "FfdfsdfdF9fdsf.fdsfdf98FDkzfdA3122.J83TqjxRzmuDuruBChNT8sMg5tfRi5iQ6tUlqJb3M9U", isAdmin: true)
}
