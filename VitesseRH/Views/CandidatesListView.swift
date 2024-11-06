//
//  CandidatsView.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 21/10/2024.
//

import SwiftUI

struct CandidatesListView: View {
    
    @ObservedObject var viewModel: CandidatesListViewModel
    
    @State private var addCandidate = false
    
    var body: some View {
        VStack {
            HStack {
                LogoView(width: 100, height: 20)
                Spacer()
                Text("Candidates").bold()
                
                
            }.padding()
            Spacer()
            
            ForEach(viewModel.candidates, id: \.id) { (candidate: Candidate) in
                
                VStack() {
                    HStack(alignment: .center) {
                        Text(candidate.lastName)
                        Spacer()
                        Text (candidate.firstName)
                    }
                }.frame(maxWidth: 200)
            }
            Spacer()
            
            
            Button(action: {viewModel.navigation.navigateToAddCandidate()}) {
                Text("Add Candidate")
                    .frame(maxWidth: 200)
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()
                    .background(Color("ButtonColor"))
                    .cornerRadius(10)
            }
        }
        .applyBackground(Color("BackgroundColor"))
        .onAppear() {
            Task {
                await viewModel.getListCandidates()
            }
            
        }
        .navigationBarBackButtonHidden(true)
        
    }
}

#Preview {
    let navigation = NavigationViewModel()
    let viewModel = CandidatesListViewModel(apiService: APIClient(),navigation: navigation)
    CandidatesListView(viewModel: viewModel)
}
