//
//  NavigationViewModel.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 03/11/2024.
//

import Foundation
import SwiftUI
class NavigationViewModel: ObservableObject {
    @Published var path = NavigationPath()

    func navigateTo(dest: Navigation) {
        path.append(dest)
    }

    func resetNavigation() {
        path.removeLast(path.count)
    }
    
    func navigateToCandidatesList()
    {
        navigateTo(dest: .candidatesList)
    }
    
    func navigateToRegister()
    {
        navigateTo(dest: .register)
    }
    
    func navigateToAddCandidate()
    {
        navigateTo(dest: .addCandidate)
    }
    
    func goBack() {
        if (path.count>0) {
            path.removeLast()
        }
    }
    
    
    
    
}

enum Navigation {
    case login
    case candidatesList
    case candidate
    case addCandidate
    case register
}
