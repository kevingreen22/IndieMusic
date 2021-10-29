//
//  ArtistNavLinkCell.swift
//  IndieMusic
//
//  Created by Kevin Green on 10/21/21.
//

import SwiftUI

struct ArtistNavLinkCell: View {
    @EnvironmentObject var vm: MainViewModel
    @State private var isFavorited: Bool = false
    let artist: Artist
    let imageWidth: CGFloat = 50
    let imageHeight: CGFloat = 50
    
    var body: some View {
        NavigationLink(
            destination: AlbumsView(albums: artist.albums),
            label: {
                HStack {
                    Image(uiImage: vm.fetchBioImageFor(artist: artist))
                        .resizable()
                        .frame(width: imageWidth, height: imageHeight)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(3)
                        .clipShape(Circle())
                        .padding(4)
                    Text(artist.name).foregroundColor(Color.theme.primaryText).fontWeight(.semibold)
                    Spacer()
                    FarvoriteHeartView(typeOfFavorite: Artist.self, isFavorited: $isFavorited)
                        .padding(.trailing)
                }
            }
        ).frame(height: 54)
    }
}

struct ArtistNavLinkCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ArtistNavLinkCell(artist: dev.artists.first!)
                .environmentObject(dev.mainVM)
                .previewLayout(.sizeThatFits)
            
            ArtistNavLinkCell(artist: dev.artists.first!)
                .environmentObject(dev.mainVM)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
