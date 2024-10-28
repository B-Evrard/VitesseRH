//
//  LoginView.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 18/10/2024.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var viewModel: LoginViewModel
    @State private var navigateToRegister = false
    
    var body: some View {
        NavigationStack {
            
            ZStack{
                Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)
                
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
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Spacer()
                        Text("Password")
                            .font(.headline)
                        SecureField("", text: $viewModel.password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Spacer()
                        
                        Text("Forgot password ?")
                        
                    }.padding(40)
                        .frame(width: 335, height: 150)
                    
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
                        }.navigationDestination(
                            isPresented: $viewModel.isLogged) {
                                CandidatsView()
                            }
                        
                        Spacer()
                        
                        // Button Register
                        Button(action: {
                            navigateToRegister = true
                        }) {
                            Text("Register")
                                .frame(maxWidth: 100)
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding()
                                .background(Color("ButtonColor"))
                                .cornerRadius(10)
                            
                        }.navigationDestination(
                            isPresented: $navigateToRegister) {
                                RegisterView(viewModel: RegisterViewModel(apiService: APIClient()))
                            }
                    }
                    .frame(width: 200, height: 130)
                    Spacer()
                    
                    Text(viewModel.messageAlert)
                        .transition(.move(edge: .top))
                        .foregroundColor(.red)
                    Spacer()
                }
                .padding()
            }
        }
    }
}


#Preview {
    let viewModel = LoginViewModel(apiService: APIClient())
    LoginView(
        viewModel: viewModel)
}
