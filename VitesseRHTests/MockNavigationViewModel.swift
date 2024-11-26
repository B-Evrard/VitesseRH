//
//  MockNavigationViewModel.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 26/11/2024.
//


import XCTest
class MockNavigationViewModel: NavigationViewModel {
    var navigateToCandidateCalled = false
    var passedCandidateID: String?

    override func navigateToCandidate(id: String) {
        navigateToCandidateCalled = true
        passedCandidateID = id
    }
}
