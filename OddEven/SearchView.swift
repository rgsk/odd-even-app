//
//  SearchView.swift
//  OddEven
//
//  Created by Rahul Gupta on 15/07/23.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = PlayerViewModel()
    @State var searchQuery: String = ""
    @State var selectedPlayers: [String]
    @State var selectedPlayersInCurrentSession: [String] = []
    let onCancel: () -> ()
    let onDone: (_ newSelectedPlayers:[String]) -> ()
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Button(action: {
                        onCancel()
                    }) {
                        Text("Cancel")
                    }
                    Spacer()
                    Button(action: {
                        onDone(selectedPlayers)
                    }) {
                        Text("Done")
                    }
                }.padding()
                
                TextField("Search", text: $searchQuery)
                    .padding(.horizontal)
                    .onChange(of: searchQuery) { query in
                        viewModel.filterPlayers(with: query)
                    }
                    .focused($isTextFieldFocused)
                    .onAppear {
                        isTextFieldFocused = true
                    }
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
                    .padding()
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



struct SearchViewWrapperView: View {
    var body: some View {
        SearchView(selectedPlayers: ["Suresh Raina"], onCancel: {
        }, onDone: { newSelectedPlayers in
            
        })
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchViewWrapperView()
    }
}
