//
//  SelectedItemPillView.swift
//  OddEven
//
//  Created by Rahul Gupta on 15/07/23.
//

import SwiftUI

struct SelectedItemPillView: View {
    let player: String
    let onCrossClick: () -> ()
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Text(player)
                .padding(.vertical, 6)
                .padding(.horizontal,12)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(15)
                .frame(maxWidth: 100)
                .lineLimit(1)
                .truncationMode(.tail)
                
                
            
            Button(action: {
                onCrossClick()
            }) {
                Image(systemName: "xmark.circle.fill")
            }.offset(y:-12)
                .padding(.trailing,-12)
            
        }
    }
}


struct SelectedItemPillView_Previews: PreviewProvider {
    static let players = ["Rahul", "Mehak long"]
    static var previews: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(players, id: \.self) { player in
                    SelectedItemPillView(player: player, onCrossClick: {
                    })
                    
                }
            }
            .padding()
        }
    }
}
