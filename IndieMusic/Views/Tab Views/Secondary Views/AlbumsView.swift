//
//  AlbumsView.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/8/21.
//

import SwiftUI

struct AlbumsView: View {
    @EnvironmentObject var vm: ViewModel
    var albums: [Album]
    
    private let columns: [GridItem] = [
        GridItem(.flexible(minimum: 100)),
        GridItem(.flexible(minimum: 100))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(albums, id: \.self ) { album in
                    NavigationLink(
                        destination: SongsListView(songs: album.songs, album: nil),
                        label: {
                            AlbumNavLinkView(album: album)
                                .environmentObject(vm)
                        })
                }
            }.padding()
        }
        .navigationBarTitle("Albums", displayMode: .large)
    }
}



struct AlbumNavLinkView: View {
    @EnvironmentObject var vm: ViewModel
    @State private var isFavorited: Bool = false
    let album: Album

    var body: some View {
        VStack {
            Image(uiImage: vm.albumImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(5)
            HStack {
                VStack(alignment: .leading) {
                    Text(album.title)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .foregroundColor(.black)
                        .font(.title3)
                    Text(album.artistName)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .foregroundColor(.gray)
                        .font(.body)
                }
                Spacer()
                FarvoriteStarView(typeOfFavorite: Album.self, isFavorited: $isFavorited)
            }.padding(.horizontal)
        }
    }
}




struct AlbumsView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumsView(albums: MockData.Albums())
    }
}
