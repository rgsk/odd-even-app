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
            if isSearchFocused {
                SearchView(selectedPlayers: selectedPlayers, onCancel: {
                    withAnimation{
                        isSearchFocused = false
                    }
                }, onDone: { newSelectedPlayers in
                    withAnimation{
                        selectedPlayers = newSelectedPlayers
                        isSearchFocused = false
                    }
                })
                .modifier(AnimateOpacity())
            } else {
                TextField("Search", text: $searchQuery)
                    .padding()
                    .onTapGesture {
                        withAnimation {
                            isSearchFocused = true
                        }
                    }
                Divider()
                VStack {
                    Text("Selected Players:")
                        .font(.headline)
                    
                    List {
                        ForEach(selectedPlayers, id: \.self) { player in
                            Text(player)
                        }
                        .onMove(perform: movePlayer)
                    }
                }.padding(.top,12)
                    .modifier(AnimateOpacity())
            }
            
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

struct AnimateOpacity: ViewModifier {
    func body(content: Content) -> some View {
        content
            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.1)))
    }
}





struct SelectTeamView_Previews: PreviewProvider {
    static var previews: some View {
        SelectTeamView()
    }
}
