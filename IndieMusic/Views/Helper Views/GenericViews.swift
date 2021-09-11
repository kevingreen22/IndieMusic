//
//  GenericViews.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/19/21.
//

import SwiftUI

struct GenericListCell: View {
    @EnvironmentObject var vm: ViewModel
    let imageName: String
    let label: String
    let typeOfFavorite: Any?
    let imageWidth: CGFloat = 30
    let imageHeight: CGFloat = 30
    @State private var isFavorited: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .resizable()
                .frame(width: imageWidth, height: imageHeight)
                .aspectRatio(contentMode: .fit)
                .cornerRadius(3)
            Text(label)
            Spacer()
            if typeOfFavorite != nil {
                FarvoriteHeartView(typeOfFavorite: typeOfFavorite, isFavorited: $isFavorited)
            }
        }.padding(.horizontal)
    }
}



struct FarvoriteHeartView: View {
    @EnvironmentObject var vm: ViewModel
    let typeOfFavorite: Any?
    @Binding var isFavorited: Bool
    
    var body: some View {
        Image(systemName: isFavorited ? "heart.fill" : "heart")
            .foregroundColor(.red)
            .highPriorityGesture(
                TapGesture().onEnded({ () in
                    isFavorited.toggle()
                    
                    print("favorited")
                    switch typeOfFavorite {
                    case is Song.Type:
                        guard let song = typeOfFavorite as? Song else { return }
                        vm.user.favoriteSongs?.append(song)
                    case is Album.Type:
                        guard let album = typeOfFavorite as? Album else { return }
                        vm.user.favoriteAlbums?.append(album)
                    case is Artist.Type:
                        guard let artist = typeOfFavorite as? Artist else { return }
                        vm.user.favoriteArtists?.append(artist)
                    case .none, .some(_):
                        break
                    }
                })
            )
    }
}











struct GenericViews_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GenericListCell(imageName: "dillinger",
                            label: "Dillinger",
                            typeOfFavorite: Song.self)
        }
    }
}
