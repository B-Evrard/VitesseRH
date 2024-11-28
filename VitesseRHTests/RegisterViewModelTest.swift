//
//  RegisterViewModelTest.swift
//  VitesseRHTests
//
//  Created by Bruno Evrard on 25/11/2024.
//

import XCTest

final class RegisterViewModelTest: XCTestCase {
    
    @MainActor
    func testControlRegister() async {
        
        let session = MockUrlSession()
        
        // To be able to use the Endpoint user_register in the HTTPURLResponse, we instantiate a registerUser
        let registerUserTemp: RegisterUser = .init(email: "", password: "", firstName: "", lastName: "")
        let endpoint = Endpoint.user_register(registerUser: registerUserTemp)
        session.urlResponse = HTTPURLResponse(url: endpoint.api , statusCode: 200, httpVersion: nil, headerFields: nil)
        let mockApiClient = MockApiClient(session: session)
        
        let viewModel = RegisterViewModel(apiService: mockApiClient, navigation: NavigationViewModel())
        
        viewModel.raz()
        
        // empty firstName
        await viewModel.register()
        
        XCTAssertEqual(viewModel.messageAlert, ControlError.firstNameEmpty().message)
        
        // empty lastName
        viewModel.firstName = "Bruno"
        await viewModel.register()
        XCTAssertEqual(viewModel.messageAlert, ControlError.lastNameEmpty().message)
        
        // empty email
        viewModel.lastName = "Evrard"
        await viewModel.register()
        XCTAssertEqual(viewModel.messageAlert, ControlError.mailEmpty().message)
        
        // invalid email
        viewModel.email = "test&test.fr"
        await viewModel.register()
        XCTAssertEqual(viewModel.messageAlert, ControlError.invalidFormatMail().message)
        
        // empty password
        viewModel.email = "test@test.fr"
        await viewModel.register()
        XCTAssertEqual(viewModel.messageAlert, ControlError.passwordEmpty().message)
        
        // Passwords do not match.
        viewModel.password = "123"
        await viewModel.register()
        XCTAssertEqual(viewModel.messageAlert, ControlError.passwordNotMatch().message)
    }
    
    @MainActor
    func testRegisterSuccess() async {
        let session = MockUrlSession()
        
        // To be able to use the Endpoint user_register in the HTTPURLResponse, we instantiate a registerUser
        let registerUserTemp: RegisterUser = .init(email: "", password: "", firstName: "", lastName: "")
        let endpoint = Endpoint.user_register(registerUser: registerUserTemp)
        session.urlResponse = HTTPURLResponse(url: endpoint.api , statusCode: 200, httpVersion: nil, headerFields: nil)
        let mockApiClient = MockApiClient(session: session)
        
        let viewModel = RegisterViewModel(apiService: mockApiClient, navigation: NavigationViewModel())
        
        viewModel.firstName = "Bruno"
        viewModel.lastName = "Evrard"
        viewModel.email = "test@test.fr"
        viewModel.password = "123"
        viewModel.confirmedPassword = "123"
        
        session.data = "".data(using: .utf8)
        session.urlResponse = HTTPURLResponse(url: endpoint.api , statusCode: 200, httpVersion: nil, headerFields: nil)
        await viewModel.register()
        XCTAssertTrue(viewModel.showMessage)
    }
    
    @MainActor
    func testRegisterFailure() async {
        let session = MockUrlSession()
        
        // To be able to use the Endpoint user_register in the HTTPURLResponse, we instantiate a registerUser
        let registerUserTemp: RegisterUser = .init(email: "", password: "", firstName: "", lastName: "")
        let endpoint = Endpoint.user_register(registerUser: registerUserTemp)
        session.urlResponse = HTTPURLResponse(url: endpoint.api , statusCode: 200, httpVersion: nil, headerFields: nil)
        let mockApiClient = MockApiClient(session: session)
        
        let viewModel = RegisterViewModel(apiService: mockApiClient, navigation: NavigationViewModel())
        
        viewModel.firstName = "Bruno"
        viewModel.lastName = "Evrard"
        viewModel.email = "test@test.fr"
        viewModel.password = "123"
        viewModel.confirmedPassword = "123"
        
        session.data = error500.data(using: .utf8)
        session.urlResponse = HTTPURLResponse(url: endpoint.api , statusCode: 500, httpVersion: nil, headerFields: nil)
        await viewModel.register()
        XCTAssertEqual(viewModel.messageAlert, APIError.userExists().message)
    }
    
    let error500 = """
    {
    "reason": "constraint: UNIQUE constraint failed: users.email",
    "error": true
    }
    """
    
    
}
