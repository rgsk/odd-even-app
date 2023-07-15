//
//  SelectTeamView.swift
//  OddEven
//
//  Created by Rahul Gupta on 15/07/23.
//

import SwiftUI

struct SelectTeamView: View {
    @StateObject private var viewModel = PlayerViewModel()
       @State private var searchPrefix = ""

       var body: some View {
           VStack {
               TextField("Search", text: $searchPrefix)
                   .padding()
                   .onChange(of: searchPrefix) { prefix in
                       viewModel.filterPlayers(with: prefix)
                   }
               
               ScrollView {
                   LazyVStack {
                       ForEach(viewModel.displayedPlayers) { player in
                           Text(player.name)
                               .onAppear {
                                   if isLastPlayer(player) {
                                       viewModel.loadMorePlayers()
                                   }
                               }
                       }
                      
                   }
               }
           }
       }
       
       func isLastPlayer(_ item: CricketPlayer?) -> Bool {
           guard let item = item else { return false }
           guard let lastPlayer = viewModel.displayedPlayers.last else { return false }
           return item.id == lastPlayer.id
       }
}

struct SelectTeamView_Previews: PreviewProvider {
    static var previews: some View {
        SelectTeamView()
    }
}
