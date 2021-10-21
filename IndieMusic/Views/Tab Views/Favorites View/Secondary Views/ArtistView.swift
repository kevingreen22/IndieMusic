//
//  ArtistView.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/8/21.
//

import SwiftUI

struct ArtistsView: View {
    @EnvironmentObject var vm: MainViewModel
    @Environment(\.defaultMinListRowHeight) var listRowHeight
    let artists: [Artist]
    
    var body: some View {
        List {
            ForEach(artists, id: \.self) { artist in
                ArtistNavLinkCell(artist: artist)
                    .environmentObject(vm)
                    .listRowBackground(Color.clear)
            }
        }
        .environment(\.defaultMinListRowHeight, 60)
        .navigationBarTitle("Artists", displayMode: .large)
    }
}







struct ArtistView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistsView(artists: dev.artists)
            .environmentObject(dev.mainVM)
    }
}
