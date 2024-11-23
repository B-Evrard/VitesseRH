//
//  LoginViewModelTest.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 21/11/2024.
//

import XCTest

final class LoginViewModelTest: XCTestCase {
    @MainActor
    func testControl() async {
        
        
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
        
        // Login Ok
        viewModel.email = "test@test.com"
        viewModel.password = "123456"
        await viewModel.authenticate()
        
        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(viewModel.messageAlert.isEmpty)
        
    }
    
    let token = """
    {
    "token": "FfdfsdfdF9fdsf.fdsfdf98FDkzfdA3122.J83TqjxRzmuDuruBChNT8sMg5tfRi5iQ6tUlqJb3M9U",
    "isAdmin": false
    }
    """

}
