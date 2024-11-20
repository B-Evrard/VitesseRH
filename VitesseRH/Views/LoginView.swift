//
//  LoginView.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 18/10/2024.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var viewModel: LoginViewModel
    @StateObject private var navigation = NavigationViewModel()
    @State private var navigateToRegister = false
    
    
    var body: some View {
        NavigationStack(path: $navigation.path) {
            
            VStack {
                
                LogoView()
                Spacer()
                
                Text("Login")
                    .font(.largeTitle)
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Email/Username")
                        .font(.headline)
                    TextField("", text: $viewModel.email)
                        .autocorrectionDisabled(true)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 10)
                    
                    Spacer()
                    
                    Text("Password")
                        .font(.headline)
                    SecureField("", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 10)
                    Spacer()
                    
                    Text("Forgot password ?")
                    
                }.padding(10)
                    .frame(width: 335, height: 200)
                
                Spacer()
                
                VStack(alignment: .center) {
                    
                    // Button Sign in
                    Button(action: {
                        Task {
                            await viewModel.authenticate()
                        }
                        
                    }) {
                        Text("Sign in")
                            .frame(maxWidth: 100)
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color("ButtonColor"))
                            .cornerRadius(10)
                    }
                    
                    Spacer()
                    
                    // Button Register
                    Button(action: {
                        navigation.navigateToRegister()
                        
                    }) {
                        Text("Register")
                            .frame(maxWidth: 100)
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color("ButtonColor"))
                            .cornerRadius(10)
                        
                    }
                    
                }.frame(width: 335, height: 150)
                
                Spacer()
                
                Text(viewModel.messageAlert)
                    .foregroundColor(.red)
                
                Spacer()
                
            }
            .applyBackground([Color("BackgroundColorFrom"), Color("BackgroundColorTo")])
            .onAppear {
                viewModel.raz()
            }
            .navigationDestination(for: Navigation.self) { destination in
                switch destination {
                case .register:
                    RegisterView(viewModel: RegisterViewModel(apiService: APIClient(), navigation: navigation))
                    
                default:    EmptyView()
                }
            }
        }
        
    }
    
}




#Preview {
    let viewModel = AppViewModel()
    LoginView(viewModel: LoginViewModel(apiService: APIClient()) { token in
        viewModel.isLogged = true
        viewModel.tokenManager.tokenStorage.token = token
    })
}
