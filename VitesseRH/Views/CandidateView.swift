//
//  CandidateView.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 01/11/2024.
//

import SwiftUI

struct CandidateView: View {
    
    @ObservedObject var viewModel: CandidateViewModel
    @StateObject  var navigation: NavigationViewModel
    
    var body: some View {
        
        
        VStack {
            
            VStack(alignment: .leading) {
                
                HeaderView(viewModel: viewModel)
                
                DetailView(viewModel: viewModel)
                
                NoteView(viewModel: viewModel)
                
            }.padding(10)
                .frame(width: 335, height: 700)
            
            Text(viewModel.messageAlert)
                .transition(.move(edge: .top))
                .foregroundColor(.red)
            Spacer()
        }
        .alert("", isPresented: $viewModel.showMessage) {
            Button("OK", role: .cancel) {
                if (viewModel.isAddMode) {
                    navigation.goBack()
                }
                else {
                    viewModel.mode = .view
                }
                
            }
        } message: {
            Text(viewModel.isAddMode ? "Candidate added successfully." :"Candidate updated successfully.")
        }
        .applyBackground([Color("BackgroundColorFrom"), Color("BackgroundColorTo")])
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Button {
                        if (viewModel.isEditMode && !viewModel.isAddMode) {
                            viewModel.mode = .view
                        }
                        else {
                            navigation.goBack()
                        }
                        
                    } label: {
                        if (viewModel.isEditMode) {
                            Text("Cancel")
                        }
                        else {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.blue)
                        }
                        
                    }
                    Spacer()
                    LogoView(width: 165,height: 50)
                    Spacer()
                    Button {
                        
                        if (viewModel.isEditMode) {
                            Task {
                                await viewModel.validate()
                            }
                        }
                        else {
                            viewModel.mode = .edit
                        }
                        
                        
                    } label: {
                        Text(!viewModel.isEditMode  ? "Edit" : "Done")
                    }
                    
                }
                .frame(width: 350)
                
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear() {
            Task {
                await viewModel.readCandidate()
            }
            
        }
    }
    
}



struct HeaderView: View {
    
    @ObservedObject var viewModel: CandidateViewModel
    var body: some View {
        if (viewModel.isAddMode) {
            Spacer()
            Text("First Name")
                .font(.headline)
            TextField("", text: $viewModel.firstName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)
            
            
            Text("Last Name")
                .font(.headline)
            TextField("", text: $viewModel.lastName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)
        }
        else {
            
            HStack (alignment: .center){
                Text(viewModel.name)
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Spacer()
                
                if (viewModel.isAllowedEditFavorite) {
                    Image(systemName: viewModel.favorite ? "star.fill" : "star")
                        .scaledToFit()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                viewModel.favorite.toggle()
                            }
                            Task {
                                await viewModel.updateFavorite()
                            }
                            
                        }
                }
                else {
                    Image(systemName: viewModel.favorite ? "star.fill" : "star")
                        .foregroundColor(.black)
                        .padding()
                }
                
                
            }.frame(width: 335, height: 100)
            
        }
    }
}

struct DetailView: View {
    @ObservedObject var viewModel: CandidateViewModel
    var body: some View {
        if (viewModel.isEditMode) {
            
            Text("Phone")
                .font(.headline)
            TextField("", text: $viewModel.phone)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)

            Text("Email")
                .font(.headline)
            TextField("", text: $viewModel.email)
                .autocorrectionDisabled(true)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)

            Text("LinkedIn")
                .font(.headline)
            TextField("", text: $viewModel.linkedIn)
                .autocorrectionDisabled(true)
                .keyboardType(.URL)
                .textInputAutocapitalization(.never)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)
        } else {
            
            HStack {
                Text("Phone")
                    .padding(.bottom, 10)
                    .frame(width: 80, alignment: .leading)
                Text(viewModel.phone)
                    .padding(.bottom, 10)
            }
            
            HStack {
                Text("Email")
                    .padding(.bottom, 10)
                    .frame(width: 80, alignment: .leading)
                Text(viewModel.email)
                    .padding(.bottom, 10)
            }
 
            HStack {
                Text("LinkedIn ")
                    .frame(width: 80, alignment: .leading)
                if (viewModel.isLinkedInURLValid) {
                    Link("Go on Linkedin", destination: URL(string: viewModel.linkedIn)!)
                        .frame(width: 150, height: 5)
                        .padding()
                        .foregroundColor(.black)
                        .background(Color("ButtonColor"))
                        .cornerRadius(8)
                }
            }.padding(.bottom, 10)
        }
    }
}


struct NoteView: View {
    @ObservedObject var viewModel: CandidateViewModel
    var body: some View {
        Text("Note")
            .font(viewModel.isAddMode ? .headline : .body)
        if (!viewModel.isEditMode)
        {
            ScrollView {
                Text(viewModel.note)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.black, lineWidth: 1)
            }
            .frame(height: 250)
        }
        else
        
        {
            TextEditor(text: $viewModel.note)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.black, lineWidth: 1)
                }
                .frame(height: 250)
        }
    }
}


//#Preview {
//    let navigation = NavigationViewModel()
//    let viewModel = CandidateViewModel(apiService: APIClient(), navigation: navigation)
//    CandidateView(viewModel: viewModel)
//}

struct CandidateDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let navigation = NavigationViewModel()
        let viewModelAdd = CandidateViewModel(apiService: APIClient())
        let viewModelVisu = CandidateViewModel(apiService: APIClient(),mode: .view, id: "68ACD0E9-2BA8-41C7-B0B7-8576D53183E2")
        
        
        
        CandidateView(viewModel: viewModelVisu, navigation: navigation)
            .previewDisplayName("Mode Édition")
        
        CandidateView(viewModel: viewModelAdd,navigation: navigation)
            .previewDisplayName("Mode Création")
        
    
    }
}
