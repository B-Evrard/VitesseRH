//
//  RegisterViewModels.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 21/10/2024.
//

import Foundation

class RegisterViewModels: ObservableObject {
   
    @Published var user: User?
    
    private let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
}
