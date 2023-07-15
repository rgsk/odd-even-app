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

       var body: some View {
           VStack {
               TextField("Search", text: $searchQuery)
                   .padding()
                   .onChange(of: searchQuery) { query in
                       viewModel.filterPlayers(with: query)
                   }
               
               ScrollView {
                   LazyVStack {
                       ForEach(viewModel.displayedPlayers, id: \.self) { player in
                           Text(player)
                               .onAppear {
                                   if player == viewModel.displayedPlayers.last {
                                       viewModel.loadMorePlayers()
                                   }
                               }
                       }
                      
                   }
               }
           }
       }
       
  
}

struct SelectTeamView_Previews: PreviewProvider {
    static var previews: some View {
        SelectTeamView()
    }
}
