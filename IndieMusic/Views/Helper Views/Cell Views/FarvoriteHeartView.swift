//
//  FarvoriteHeartView.swift
//  IndieMusic
//
//  Created by Kevin Green on 10/21/21.
//

import SwiftUI

struct FarvoriteHeartView: View {
    @EnvironmentObject var vm: MainViewModel
    let typeOfFavorite: Any?
    @Binding var isFavorited: Bool
    
    var body: some View {
        Image(systemName: isFavorited ? "heart.fill" : "heart")
            .foregroundColor(.red)
            .highPriorityGesture(
                TapGesture().onEnded({ () in
                    isFavorited.toggle()
                    
                    guard let user = vm.user else { return }
                    print("favorited")
                    switch typeOfFavorite {
                    case is Song.Type:
                        guard let song = typeOfFavorite as? Song else { return }
                        user.favoriteSongs.append(song)
                    case is Album.Type:
                        guard let album = typeOfFavorite as? Album else { return }
                        user.favoriteAlbums.append(album)
                    case is Artist.Type:
                        guard let artist = typeOfFavorite as? Artist else { return }
                        user.favoriteArtists.append(artist)
                    case .none, .some(_):
                        break
                    }
                })
            )
    }
}




struct FarvoriteHeartView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FarvoriteHeartView(typeOfFavorite: nil, isFavorited: .constant(true))
                .previewLayout(.sizeThatFits)
            
            FarvoriteHeartView(typeOfFavorite: nil, isFavorited: .constant(true))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
