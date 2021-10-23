//
//  FavoritesView.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/20/21.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var vm: MainViewModel
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        if AuthManager.shared.isSignedIn {
            List {
                NavigationLink(destination: ArtistsView(artists: vm.user?.favoriteArtists ?? [])
                                .environmentObject(vm),
                               label: {
                    FavoritesNavLinkCell(systemImageName: "music.mic", label: "Artists")
                }).listRowBackground(Color.clear)
                
                NavigationLink(destination: AlbumsView(albums: vm.user?.favoriteAlbums ?? []),
                               label: {
                    FavoritesNavLinkCell(systemImageName: "music.note.list", label: "Albums")
                }).listRowBackground(Color.clear)
                
                NavigationLink(destination: SongsListView(songs: vm.user?.favoriteSongs ?? [], album: nil),
                               label: {
                    FavoritesNavLinkCell(systemImageName: "music.note", label: "Songs")
                })
                
                
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
                                    AlbumNavLinkCellView(album: recent)
                                })
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            
        } else {
            Button {
                vm.activeSheet = .signIn
            } label: {
                Text("Sign In")
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(width: 300, height: 55)
                    .background(Color.theme.primary)
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}









struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FavoritesView()
                .environmentObject(dev.mainVM)
            
            FavoritesView()
                .environmentObject(dev.mainVM)
                .preferredColorScheme(.dark)
        }
    }
}
