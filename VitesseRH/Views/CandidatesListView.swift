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
                        viewModel.switchEditOrViewMode()
                    } label: {
                        Text(!viewModel.isEdit  ? "Edit" : "Cancel")
                            .foregroundColor(Color("ButtonColor"))
                    }
                    Spacer()
                    
                    Text("Candidates").bold()
                    Spacer()
                    
                    Button {
                        if viewModel.isEdit {
                            Task {
                                await viewModel.deleteCandidates()
                            }
                            
                        }
                    } label: {
                        if (viewModel.isEdit) {
                            Text("Delete")
                                .foregroundColor(Color("ButtonColor"))
                        } else {
                            Image(systemName: viewModel.isFilterFav ? "star.fill" : "star")
                                .scaledToFit()
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        viewModel.isFilterFav.toggle()
                                    }
                                    viewModel.filterAndSortCandidates()
                                }
                                .foregroundColor(Color("ButtonColor"))
                            
                        }
                        
                    }
                    
                    
                }.padding(25)
                Spacer()
                
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search", text: $viewModel.search)
                        .autocorrectionDisabled(true)
                        .textFieldStyle(PlainTextFieldStyle())
                        .onChange(of: viewModel.search) {
                            viewModel.filterAndSortCandidates()
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
                    ForEach($viewModel.candidatesFilter, id: \.id) {  $candidate in
                        Button(action: {
                            viewModel.viewCandidate(navigation: navigation, candidate: candidate)
                        }) {
                            HStack {
                                
                                if (viewModel.isEdit) {
                                    Button(action: {
                                        candidate.isSelected.toggle()
                                    }) {
                                        Image(systemName: candidate.isSelected ? "checkmark.circle.fill" : "circle")
                                    }.padding(5)
                                }
                                
                                Text(candidate.name)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .padding(.vertical, 15)
                                    .padding(.horizontal, viewModel.isEdit ? 0 : 5)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                Spacer()
                                Image(systemName: candidate.isFavorite ? "star.fill" : "star")
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
                
                HStack {
                    Text(viewModel.messageAlert)
                        .transition(.move(edge: .top))
                        .foregroundColor(.red)
                    Spacer()
                    Button(action: {navigation.navigateToAddCandidate()}) {
                        HStack {
                            
                            Image(systemName: "person.badge.plus")
                                .font(.title)
                                .foregroundColor(Color("ButtonColor"))
                        }
                        
                        
                    }.disabled(viewModel.isEdit)
                }.padding(25)
                
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

