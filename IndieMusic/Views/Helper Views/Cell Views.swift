//
//  CellViews.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/19/21.
//

import SwiftUI

struct FavoritesNavLinkCell: View {
    @EnvironmentObject var vm: ViewModel
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
    @EnvironmentObject var vm: ViewModel
    @State private var isFavorited: Bool = false
    let artist: Artist
    let imageWidth: CGFloat = 30
    let imageHeight: CGFloat = 30
    
    var body: some View {
        NavigationLink(
            destination: AlbumsView(albums: artist.albums ?? []),
            label: {
                HStack {
                    Image(artist.imageURL!.absoluteString)
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
    @EnvironmentObject var vm: ViewModel
    @State private var isFavorited: Bool = false
    let album: Album
    let imageWidth: CGFloat = 30
    let imageHeight: CGFloat = 30

    var body: some View {
        NavigationLink(
            destination: SongsListView(songs: album.songs, album: nil),
            label: {
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
                        FarvoriteHeartView(typeOfFavorite: Album.self, isFavorited: $isFavorited)
                    }.padding(.horizontal)
                }
            })
    }
}


struct SongListCell: View {
    @EnvironmentObject var vm: ViewModel
    @EnvironmentObject var cpVM: CurrentlyPlayingViewModel
    let albumArtwork: UIImage
    let song: Song
    @Binding var selectedSongCell: Song?
    @State private var isFavorited: Bool = false
    let constants = ViewModel.Constants.self
    
    var body: some View {
        ZStack {
            HStack {
                Image(uiImage: albumArtwork)
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
            CellTapped(cpVM: _cpVM, song: song, selectedSongCell: $selectedSongCell)
        )
        
    }
}

fileprivate struct CellTapped: Gesture {
    @EnvironmentObject var vm: ViewModel
    @EnvironmentObject var cpVM: CurrentlyPlayingViewModel
    let song: Song
    @Binding var selectedSongCell: Song?

    var body: some Gesture {
        TapGesture()
            .onEnded {
                selectedSongCell = song
                if song == selectedSongCell {
                    cpVM.playPauseSong()
                    cpVM.playState = .play
                    vm.user.songListData.append(song)
                }
            }
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







struct ExploreViewCell: View {
    let content: ExploreCellModel

    var body: some View {
        Rectangle()
            .fill(Color.blue)
            .overlay(
                Image(content.imageName ?? "genre_image_placeholder")
                    .resizable()
            )
            .cornerRadius(25)
            .overlay(
                VStack(alignment: .leading) {
                    Spacer()
                    Text(content.genre)
                        .foregroundColor(.white)
                        .font(.title3)
                        .bold()
                        .lineLimit(2)
                        .padding(.bottom)
                }
            )
            .frame(height: ViewModel.Constants.exploreCellSize)
            .padding(.horizontal)
    }
}


















struct FavoritesNavLinkCell_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            FavoritesNavLinkCell(systemImageName: "album_artwork_placeholder", label: "Favorites Cell")
            
            ArtistNavLinkCell(artist: MockData.Artists().first!)
            
            AlbumNavLinkCellView(album: MockData.Albums().first!)
                .environmentObject(ViewModel())
                .frame(width: 200, height: 200, alignment: .center)
        
            SongListCell(albumArtwork: UIImage(imageLiteralResourceName: "album_artwork_placeholder"), song: MockData.Songs().first!, selectedSongCell: .constant(MockData.Songs().first!))
                .environmentObject(ViewModel())
                .environmentObject(CurrentlyPlayingViewModel())
        
//            let em = ExploreViewModel()
//            ExploreViewCell(content: em.exploreCells.first!)
//                .environmentObject(ViewModel())
        }
    }
}
