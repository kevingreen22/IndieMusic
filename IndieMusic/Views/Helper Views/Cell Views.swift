//
//  CellViews.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/19/21.
//

import SwiftUI

struct FavoritesNavLinkCell: View {
    @EnvironmentObject var vm: MainViewModel
    @State private var isFavorited: Bool = false
    let systemImageName: String
    let label: String
    let imageWidth: CGFloat = 30
    let imageHeight: CGFloat = 30

    var body: some View {
        HStack {
            Image(systemName: systemImageName)
                .resizable()
                .frame(width: imageWidth, height: imageHeight)
                .aspectRatio(contentMode: .fit)
                .cornerRadius(3)
                .foregroundColor(.mainApp)
            Text(label)
        }.padding(.horizontal)
    }
}


struct ArtistNavLinkCell: View {
    @EnvironmentObject var vm: MainViewModel
    @State private var isFavorited: Bool = false
    let artist: Artist
    let imageWidth: CGFloat = 30
    let imageHeight: CGFloat = 30
    
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
                    Text(artist.name)
                    Spacer()
                    FarvoriteHeartView(typeOfFavorite: Artist.self, isFavorited: $isFavorited)
                }.padding(.horizontal)
            }
        )
    }
}


struct AlbumNavLinkCellView: View {
    @EnvironmentObject var vm: MainViewModel
    @State private var isFavorited: Bool = false
    let album: Album
    let imageWidth: CGFloat = 30
    let imageHeight: CGFloat = 30

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
                                .foregroundColor(.black)
                                .font(.title3)
                            Text(album.artistName)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .foregroundColor(.gray)
                                .font(.body)
                        }
                        Spacer()
                        FarvoriteHeartView(typeOfFavorite: Album.self, isFavorited: $isFavorited)
                    }.padding(.horizontal)
                }
            })
    }
}


struct SongListCell: View {
    @EnvironmentObject var vm: MainViewModel
    @EnvironmentObject var cpVM: CurrentlyPlayingViewModel
    let song: Song
    @Binding var selectedSongCell: Song?
    @State private var isFavorited: Bool = false
    let constants = MainViewModel.Constants.self
    
    var body: some View {
        ZStack {
            HStack {
                Image(uiImage: vm.fetchAlbumArtworkFor(song: song))
                    .resizable()
                    .frame(width: constants.songCellImageSize, height: constants.songCellImageSize)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(3)
                    .overlay(
                        ZStack {
                            if song == selectedSongCell {
                                Color.black.opacity(0.7)
                                SwimplyPlayIndicator(state: $cpVM.playState, color: .white, style: .legacy)
                                    .frame(width: constants.playIndicatorSize, height: constants.playIndicatorSize, alignment: .leading)
                            }
                        }
                        .cornerRadius(3)
                    )
                
                if cpVM.audioPlayer.isPlaying {
                    SwimplyPlayIndicator(state: $cpVM.playState, style: .legacy)
                        .frame(width: constants.playIndicatorSize, height: constants.playIndicatorSize, alignment: .leading)
                }
                
                Text(song.title)
                Spacer()
                FarvoriteHeartView(typeOfFavorite: Song.self, isFavorited: $isFavorited)
            }
        }
        .highPriorityGesture(
            CellTapped(vm: _vm, cpVM: _cpVM, song: song, selectedSongCell: $selectedSongCell)
        )
        
    }
}

fileprivate struct CellTapped: Gesture {
    @EnvironmentObject var vm: MainViewModel
    @EnvironmentObject var cpVM: CurrentlyPlayingViewModel
    let song: Song
    @Binding var selectedSongCell: Song?

    var body: some Gesture {
        TapGesture()
            .onEnded {
                selectedSongCell = song
                if song == selectedSongCell {
                    cpVM.song = song
                    vm.user.addSongToUserSongList(song: song)
                }
            }
    }
}



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



struct ExploreCellView: View {
    let image: Image?
    let title: String
    let altText: String?
    
    private let imagePlaceholder: UIImage = UIImage.genreImagePlaceholder
    
    init( image: Image?, title: String, altText: String?) {
        self.image = image
        self.title = title
        self.altText = altText
    }

    
    var body: some View {
        VStack(spacing: 8) {
            (image != nil ?
             image!.resizable()  :
                (Image(uiImage:  UIImage(named: title.lowercased()) ?? imagePlaceholder))
                .resizable())
                .scaledToFit()

            Text(title)
                .foregroundColor(.black)
                .font(.title3)
                .fontWeight(.semibold)
                .truncationMode(.tail)
            
            if altText != nil {
                Text(altText!)
                    .foregroundColor(.gray)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .truncationMode(.tail)
            }
        }
    }
}




struct CellViews_Previews: PreviewProvider {
    static let rows = [GridItem(.flexible(minimum: 150))]
    
    static var previews: some View {
        VStack {
            FavoritesNavLinkCell(systemImageName: "photo", label: "Favorites Cell")

            ArtistNavLinkCell(artist: MockData.Artists().first!)

            AlbumNavLinkCellView(album: MockData.Albums().first!)
                .environmentObject(MainViewModel())
                .frame(width: 200, height: 200, alignment: .center)

            SongListCell(song: MockData.Songs().first!, selectedSongCell: .constant(MockData.Songs().first!))
                .environmentObject(MainViewModel())
                .environmentObject(CurrentlyPlayingViewModel())
        
            ExploreCellView(image: nil, title: "Metal", altText: nil)
            
        }
    }
}
