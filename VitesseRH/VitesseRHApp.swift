//
//  VitesseRHApp.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 17/10/2024.
//

import SwiftUI

@main
struct VitesseRHApp: App {
    
    @StateObject var viewModel = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if viewModel.isLogged {
                    CandidatesListView(viewModel: CandidatesListViewModel(apiService: APIClient()))
                } else {
                    LoginView(viewModel: LoginViewModel(apiService: APIClient()) { token in
                        viewModel.isLogged = true
                        viewModel.tokenManager.tokenStorage.token = token
                    })
                    .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity),
                                                                    removal: .move(edge: .top).combined(with: .opacity)))
                    
                }
            }.animation(.easeInOut(duration: 1), value: UUID())
           
        }
    }
}
