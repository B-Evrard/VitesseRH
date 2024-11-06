//
//  CandidateView.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 01/11/2024.
//

import SwiftUI

struct CandidateView: View {
    
    @ObservedObject var viewModel: CandidateViewModel
    
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    @State var phone: String = ""
    @State var linkedIn: String = ""
    @State var note: String = ""
    
    var body: some View {
        
        
        VStack {
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("First Name")
                    .font(.headline)
                TextField("", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 10)
                
                Text("Last Name")
                    .font(.headline)
                TextField("", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 10)
                
                Text("Phone")
                    .font(.headline)
                TextField("", text: $phone)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 10)
                
                Text("Email")
                    .font(.headline)
                TextField("", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 10)
                
                Text("LinkedIn")
                    .font(.headline)
                TextField("", text: $linkedIn)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 10)
                
                Text("Note")
                    .font(.headline)
                TextEditor(text: $note)
                    .frame(height: 150)
                    .border(Color.gray, width: 1)
                    .cornerRadius(10)
                
            }.padding(40)
                .frame(width: 335, height: 700)
            
            
        }
        .applyBackground(Color("BackgroundColor"))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Button {
                        viewModel.navigation.goBack()
                    } label: {
                        Text("Cancel")
                    }
                    Spacer()
                    LogoView(width: 165,height: 50)
                    Spacer()
                    Button {
                        viewModel.Validate()
                    } label: {
                        Text("Done")
                    }
                    
                }
                .frame(width: 350)
                
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    let navigation = NavigationViewModel()
    let viewModel = CandidateViewModel(apiService: APIClient(), navigation: navigation)
    CandidateView(viewModel: viewModel)
}
