//
//  LoginViewModelTest.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 21/11/2024.
//

import XCTest

final class LoginViewModelTest: XCTestCase {
    @MainActor
    func testAuthenticate() async {
        
        
        let appViewModel = AppViewModel()
        let session = MockUrlSession()
        session.data = token.data(using: .utf8)
        let login = Login(email: "test", password: "1234")
        let endpoint = Endpoint.user_auth(login: login)
        session.urlResponse = HTTPURLResponse(url: endpoint.api , statusCode: 200, httpVersion: nil, headerFields: nil)
        let mockApiClient = MockApiClient(session: session)
        
        let viewModel = LoginViewModel (apiService: mockApiClient) { token in
            appViewModel.isLogged  = true
            appViewModel.tokenManager.tokenStorage.token = token
        }
        
        // username empty
        viewModel.email = ""
        viewModel.password = ""
        await viewModel.authenticate()
        var error: ControlError = .mailEmpty()
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.messageAlert, error.message)
        
        // mail invalid
        viewModel.email = "adressemail"
        await viewModel.authenticate()
        error = .invalidFormatMail()
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.messageAlert, error.message)
        
        // Password Empty
        viewModel.email = "test@test.com"
        viewModel.password = ""
        await viewModel.authenticate()
        error = .passwordEmpty()
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.messageAlert, error.message)
        
        // Email and password ok login OK
        viewModel.email = "test@test.com"
        viewModel.password = "123456"
        await viewModel.authenticate()
        
        do {
            let tokenTest =  try JSONDecoder().decode(Token.self, from: token.data(using: .utf8)!)
            XCTAssertFalse(viewModel.showAlert)
            XCTAssertTrue(viewModel.messageAlert.isEmpty)
            XCTAssertEqual(TokenManager.shared.tokenStorage.token?.token , tokenTest.token)
        } catch {
            XCTFail("Error decoding token")
        }
        
        // Email and password ok login NOK
        session.data = error401.data(using: .utf8)
        session.urlResponse = HTTPURLResponse(url: endpoint.api , statusCode: 401, httpVersion: nil, headerFields: nil)
        viewModel.email = "test@test.com"
        viewModel.password = "123456"
        await viewModel.authenticate()
        do {
            let errorTest =  try JSONDecoder().decode(ErrorResponse.self, from: error401.data(using: .utf8)!)
            XCTAssertTrue(viewModel.showAlert)
            XCTAssertEqual(viewModel.messageAlert, errorTest.reason)
       } catch {
           XCTFail("Error decoding token")
       }
        
        
       
        
        
    }
    
    let token = """
    {
    "token": "FfdfsdfdF9fdsf.fdsfdf98FDkzfdA3122.J83TqjxRzmuDuruBChNT8sMg5tfRi5iQ6tUlqJb3M9U",
    "isAdmin": false
    }
    """
    
    let error401 = """
    {
    "reason":"User not found.",
    "error":true
    }
    """

}
