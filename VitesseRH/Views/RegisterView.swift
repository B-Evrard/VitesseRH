//
//  RegisterView.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 19/10/2024.
//

import SwiftUI

struct RegisterView: View {
    
    @ObservedObject var viewModel: RegisterViewModel
    
    var body: some View {
        
        VStack {
            
            LogoView()
            Spacer()
            
            Text("Register")
                .font(.largeTitle)
            Spacer()
            
            VStack(alignment: .leading) {
                Text("First Name")
                    .font(.headline)
                TextField("", text: $viewModel.registerUser.firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Spacer()
                
                Text("Last Name")
                    .font(.headline)
                TextField("", text: $viewModel.registerUser.lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Spacer()
                
                Text("Email")
                    .font(.headline)
                TextField("", text: $viewModel.registerUser.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Spacer()
                
                Text("Password")
                    .font(.headline)
                SecureField("", text: $viewModel.registerUser.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Spacer()
                
                Text("Confirm Password")
                    .font(.headline)
                SecureField("", text: $viewModel.confirmedPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Spacer()
                
            }.padding(40)
                .frame(width: 335, height: 370.0)
            
            VStack(alignment: .center) {
                Button(action: {
                    Task {
                        await viewModel.register()
                    }
                    
                }) {
                    Text("Create")
                        .frame(maxWidth: 100)
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color("ButtonColor"))
                        .cornerRadius(10)
                }
            }
            .frame(width: 200, height: 50)
            .padding()
            Spacer()
            
            Text(viewModel.messageAlert)
                .transition(.move(edge: .top))
                .foregroundColor(.red)
            Spacer()
        }
        .alert("", isPresented: $viewModel.showMessage) {
            Button("OK", role: .cancel) {
                viewModel.navigation.goBack()
            }
        } message: {
            Text("User registered successfully.")
        }
        .onAppear {
            viewModel.raz()
        }
        .applyBackground(Color("BackgroundColor"))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    viewModel.navigation.goBack()
                } label: {
                    Text("Cancel")
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    
}

#Preview {
    let navigation = NavigationViewModel()
    let viewmodel = RegisterViewModel(apiService: APIClient(),navigation: navigation)
    RegisterView(viewModel: viewmodel)
}

