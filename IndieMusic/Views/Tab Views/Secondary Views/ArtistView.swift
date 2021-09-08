//
//  ArtistView.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/8/21.
//

import SwiftUI

struct ArtistsView: View {
    @Environment(\.defaultMinListRowHeight) var listRowHeight
    let artists: [Artist]
    
    var body: some View {
        List {
            ForEach(artists, id: \.self) { artist in
                NavigationLink(
                    destination: AlbumsView(albums: artist.albums ?? []),
                    label: {
                        GenericListCell(imageName: artist.mostRecentAlbumArtworkURL.relativeString, label: artist.name,
                            typeOfFavorite: Artist.self
                        )
                        
                    }
                ).listRowBackground(Color.clear)
            }
        }.environment(\.defaultMinListRowHeight, 60)
        
        .navigationBarTitle("Artists", displayMode: .large)
    }
}







struct ArtistView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistsView(artists: MockData.Artists())
    }
}
