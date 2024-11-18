//
//  CandidatsView.swift
//  VitesseRH
//
//  Created by Bruno Evrard on 21/10/2024.
//

import SwiftUI

struct CandidatesListView: View {
    
    @ObservedObject var viewModel: CandidatesListViewModel
    @StateObject private var navigation = NavigationViewModel()
    @State private var isToggled = false
    
    var body: some View {
        NavigationStack(path: $navigation.path) {
            VStack {
                HStack {
                    Button {
                        
                    } label: {
                        Text(!viewModel.isEdit  ? "Edit" : "Cancel")
                            .foregroundColor(Color("ButtonColor"))
                    }
                    Spacer()
                    
                    Text("Candidates").bold()
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: isToggled ? "star.fill" : "star")
                                        .scaledToFit()
                                        .onTapGesture {
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                isToggled.toggle()
                                            }
                                        }
                                        .foregroundColor(Color("ButtonColor"))
                    }
                    
                    
                }.padding(25)
                Spacer()
               
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search", text: $viewModel.search)
                        .textFieldStyle(PlainTextFieldStyle())
                        .onChange(of: viewModel.search) {
                            viewModel.filterCandidates()
                            }
                    Button {
                        viewModel.search.removeAll()
                    } label: {
                        Image(systemName: "x.circle")
                            .foregroundColor(viewModel.search.isEmpty ? Color.gray : Color.black)
                    }
                    
                }
                .padding(5)
                .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.black, lineWidth: 1))
                .padding(.horizontal, 25)
                
                // Liste des candidats
                ScrollView {
                    ForEach(viewModel.candidatesFilter, id: \.id) { candidate in
                        Button(action: {
                            viewModel.viewCandidate(navigation: navigation, candidate: candidate)
                        }) {
                            HStack {
                                Text(candidate.name)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                Spacer()
                                Image(systemName: "star.fill")
                                    .foregroundColor(.black)
                                    .padding(.trailing)
                            }
                            .background(Color("ButtonListColor"))
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
                            .padding(.horizontal)
                            .padding(.vertical, 2)
                        }
                    }
                }.padding(10)
                
                
                Button(action: {navigation.navigateToAddCandidate()}) {
                    HStack {
                        Spacer()
                        Image(systemName: "person.badge.plus")
                            .font(.title)
                            .foregroundColor(Color("ButtonColor"))
                    }.padding()
                    
                }
            }
            .applyBackground([Color("BackgroundColorFrom"), Color("BackgroundColorTo")])
            .navigationDestination(for: Navigation.self) { destination in
                
                switch destination {
                case .addCandidate:
                    CandidateView(viewModel: CandidateViewModel(apiService: APIClient()),navigation: navigation)
                case .candidate(let id):
                     CandidateView(viewModel: CandidateViewModel(apiService: APIClient(), mode: .view, id: id),navigation: navigation)
               
                default:    EmptyView()
                }
            }
            
            .onAppear() {
                Task {
                    await viewModel.getListCandidates()
                }
                
            }
            .navigationBarBackButtonHidden(true)
            
               
            
        }
        
    }
}

#Preview {
    let viewModel = CandidatesListViewModel(apiService: APIClient())
    CandidatesListView(viewModel: viewModel)
}

