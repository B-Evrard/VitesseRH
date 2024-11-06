//
//  ContentView.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 17/10/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var navigation = NavigationViewModel()

    var body: some View {
        NavigationStack(path: $navigation.path) {
            LoginView(viewModel: LoginViewModel(apiService: APIClient(), navigation: navigation))
                .navigationDestination(for: Navigation.self) { destination in
                    switch destination {
                    case .candidatesList:
                        CandidatesListView(viewModel: CandidatesListViewModel(apiService: APIClient(), navigation: navigation))
                    case .addCandidate:
                        CandidateView(viewModel: CandidateViewModel(apiService: APIClient(), navigation: navigation))
                    case .register:
                        RegisterView(viewModel: RegisterViewModel(apiService: APIClient(), navigation: navigation))
                    default:
                        EmptyView() 
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
