//
//  AlbumNavLinkCellView.swift
//  IndieMusic
//
//  Created by Kevin Green on 10/21/21.
//

import SwiftUI

struct AlbumNavLinkCellView: View {
    @EnvironmentObject var vm: MainViewModel
    @State private var isFavorited: Bool = false
    let album: Album
  
    var body: some View {
        NavigationLink(
            destination: SongsListView(songs: album.songs, album: nil),
            label: {
                VStack {
                    Image(uiImage: vm.fetchAlbumArtworkFor(album: album))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(5)
                    HStack {
                        VStack(alignment: .leading) {
                            Text(album.title)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .foregroundColor(Color.theme.primaryText)
                                .font(.title2)
                            Text(album.artistName)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .foregroundColor(Color.theme.secondaryText)
                                .font(.body)
                        }
                        Spacer()
                        FarvoriteHeartView(typeOfFavorite: Album.self, isFavorited: $isFavorited)
                    }.padding([.horizontal, .bottom])
                }
            })
    }
}


struct AlbumNavLinkCellView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AlbumNavLinkCellView(album: dev.albums.first!)
                .environmentObject(dev.mainVM)
                .previewLayout(.sizeThatFits)
            
            AlbumNavLinkCellView(album: dev.albums.first!)
                .environmentObject(dev.mainVM)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
