//
//  VitesseRHApp.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 17/10/2024.
//

import SwiftUI

@main
struct VitesseRHApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView(viewModel: LoginViewModel(apiService: APIClient()))
        }
    }
}
