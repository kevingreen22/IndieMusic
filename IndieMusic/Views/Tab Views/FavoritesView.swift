//
//  FavoritesView.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/20/21.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var vm: ViewModel
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        List {
            NavigationLink(destination: ArtistsView(artists: vm.user?.favoriteArtists ?? []),
                           label: {
                            GenericListCell(imageName: "music.mic", label: "Artists", typeOfFavorite: nil)
                           }
            ).listRowBackground(Color.clear)
            
            NavigationLink(destination: AlbumsView(albums: vm.user?.favoriteAlbums ?? []),
                           label: {
                            GenericListCell(imageName: "music.note.list", label: "Albums", typeOfFavorite: nil)
                           }
            ).listRowBackground(Color.clear)
            
            NavigationLink(destination: SongsListView(songs: vm.user?.favoriteSongs ?? [], album: nil),
                           label: {
                            GenericListCell(imageName: "music.note", label: "Songs", typeOfFavorite: nil)
                           }
            ).listRowBackground(Color.clear)
            
            
            Text("Recently Added")
                .font(.title2)
                .bold()
                .padding(.top, 20)
                .listRowBackground(LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray]), startPoint: .top, endPoint: .bottom).opacity(0.5))
                
            LazyVGrid(columns: columns) {
                ForEach(vm.user?.recentlyAdded ?? [], id: \.self) { recent in
                    ZStack {
                        NavigationLink(
                            destination: Text("Destination"),
                            label: {
                                AlbumNavLinkView(album: recent)
                            })
                    }
                }
            }
        }
    }
}









struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .environmentObject(ViewModel())
    }
}
