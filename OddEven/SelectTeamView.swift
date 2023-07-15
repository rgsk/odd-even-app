//
//  SelectTeamView.swift
//  OddEven
//
//  Created by Rahul Gupta on 15/07/23.
//

import SwiftUI

struct SelectTeamView: View {
    @StateObject private var viewModel = PlayerViewModel()
    @State private var searchQuery = ""
    @State private var selectedPlayers: [String] = []
    @State private var isSearchFocused = false
    
    var body: some View {
        VStack {
            TextField("Search", text: $searchQuery)
                .padding()
                .onChange(of: searchQuery) { query in
                    viewModel.filterPlayers(with: query)
                }
                .onTapGesture {
                    isSearchFocused = true
                }
            
            Divider()
            
            Text("Selected Players:")
                .font(.headline)
            
            List {
                ForEach(selectedPlayers, id: \.self) { player in
                    Text(player)
                }
                .onMove(perform: movePlayer)
            }
        }
        .fullScreenCover(isPresented: $isSearchFocused) {
            SearchView(searchQuery: $searchQuery, viewModel: viewModel, selectedPlayers: $selectedPlayers, isSearchFocused: $isSearchFocused)
        }
    }
    
    private func addPlayer(_ player: String) {
        if !selectedPlayers.contains(player) {
            selectedPlayers.append(player)
        }
    }
    private func movePlayer(from source: IndexSet, to destination: Int) {
        selectedPlayers.move(fromOffsets: source, toOffset: destination)
    }
}


struct SearchView: View {
    @Binding var searchQuery: String
    @ObservedObject var viewModel: PlayerViewModel
    @Binding var selectedPlayers: [String]
    @Binding var isSearchFocused: Bool
    @State var selectedPlayersInCurrentSession: [String] = []
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Button(action: {
                        isSearchFocused = false
                        selectedPlayers = selectedPlayers.filter {!selectedPlayersInCurrentSession.contains($0)}
                    }) {
                        Text("Cancel")
                    }
                    Spacer()
                    Button(action: {
                        isSearchFocused = false
                    }) {
                        Text("Done")
                    }
                }.padding()
                
                TextField("Search", text: $searchQuery)
                    .padding(.horizontal)
                
            }
            
            if !selectedPlayersInCurrentSession.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(selectedPlayersInCurrentSession, id: \.self) { player in
                            SelectedItemPillView(player: player, onCrossClick: {
                                removePlayer(player)
                            })
                          
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            
            Divider()
            
            List(viewModel.displayedPlayers, id: \.self) { player in
                let notShow = selectedPlayers.contains(player) && !selectedPlayersInCurrentSession.contains(player)
                if !notShow {
                    Button(action: {
                        handlePlayerClick(player)
                    }) {
                        HStack {
                            Text(player)
                            Spacer()
                            if selectedPlayersInCurrentSession.contains(player) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func handlePlayerClick(_ player: String) {
        if !selectedPlayers.contains(player) {
            addPlayer(player)
        } else {
            removePlayer(player)
        }
    }
    
    private func removePlayer(_ player: String) {
        selectedPlayers.removeAll { $0 == player }
        selectedPlayersInCurrentSession.removeAll { $0 == player }
    }
    
    private func addPlayer(_ player: String) {
        selectedPlayers.append(player)
        selectedPlayersInCurrentSession.append(player);
        
    }
}

struct SelectedItemPillView: View {
    let player: String
    let onCrossClick: () -> ()
    var body: some View {
        HStack {
            Text(player)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(15)
                .frame(width:100)
                .lineLimit(1)
                      .truncationMode(.tail)
                
            Button(action: {
                onCrossClick()
            }) {
                Image(systemName: "xmark.circle.fill")
            }
        }
    }
}

struct SelectTeamView_Previews: PreviewProvider {
    static var previews: some View {
        SelectTeamView()
    }
}
