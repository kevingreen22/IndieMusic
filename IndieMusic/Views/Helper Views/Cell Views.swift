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
                .foregroundColor(.primary)
            Text(label)
        }
    }
}


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
                    Text(artist.name).foregroundColor(.black).fontWeight(.semibold)
                    Spacer()
                    FarvoriteHeartView(typeOfFavorite: Artist.self, isFavorited: $isFavorited)
                }
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
                                SwimplyPlayIndicator(state: $cpVM.playState, color: .primary, style: .legacy)
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


struct ExploreCellView: View {
    
    enum ExploreCellLayoutType {
        case square, list
    }
    
    let imageName: String?
    let title: String
    let altText: String?
    let layoutType: ExploreCellLayoutType
    
    private let imagePlaceholder: UIImage = UIImage.genreImagePlaceholder
    
    init( imageName: String?, title: String, altText: String?, layoutType: ExploreCellLayoutType = .square) {
        self.imageName = imageName
        self.title = title
        self.altText = altText
        self.layoutType = layoutType
    }

    var body: some View {
        switch layoutType {
        case .square:
            VStack(spacing: 8) {
                if imageName != nil {
                 Image(imageName!)
                        .resizable()
                        .scaledToFit()
                }

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
        case .list:
            HStack {
                if imageName != nil {
                 Image(imageName!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
                    
                VStack {
                    Text(title)
                        .foregroundColor(Color.primary)
                        .font((altText != nil) ? .title3 : .title)
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



struct CellViews_Previews: PreviewProvider {
    static let rows = [GridItem(.flexible(minimum: 150))]
    
    static var previews: some View {
        Group {
            FavoritesNavLinkCell(systemImageName: "photo", label: "Favorites Cell")
                .previewLayout(.sizeThatFits)
            
            FavoritesNavLinkCell(systemImageName: "photo", label: "Favorites Cell")
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
            
            
            ArtistNavLinkCell(artist: dev.artists.first!)
                .environmentObject(dev.mainVM)
                .previewLayout(.sizeThatFits)
            
            ArtistNavLinkCell(artist: dev.artists.first!)
                .environmentObject(dev.mainVM)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
            
            
            AlbumNavLinkCellView(album: dev.albums.first!)
                .environmentObject(dev.mainVM)
                .frame(width: 200, height: 200, alignment: .center)
                .previewLayout(.sizeThatFits)
            
            AlbumNavLinkCellView(album: dev.albums.first!)
                .environmentObject(dev.mainVM)
                .frame(width: 200, height: 200, alignment: .center)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
            
            
            SongListCell(song: dev.songs.first!, selectedSongCell: .constant(dev.songs.first!))
                .environmentObject(dev.mainVM)
                .environmentObject(dev.currentlyPlaingVM)
                .previewLayout(.sizeThatFits)
            
            SongListCell(song: dev.songs.first!, selectedSongCell: .constant(dev.songs.first!))
                .environmentObject(dev.mainVM)
                .environmentObject(dev.currentlyPlaingVM)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
            
            
            ExploreCellView(imageName: "metal", title: "Metal", altText: nil)
                .previewLayout(.sizeThatFits)
            
            ExploreCellView(imageName: "metal", title: "Metal", altText: nil)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
            
            ExploreCellView(imageName: "metal", title: "Metal", altText: nil, layoutType: .list)
                .previewLayout(.sizeThatFits)
            
            ExploreCellView(imageName: "metal", title: "Metal", altText: nil, layoutType: .list)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
            
            
            FarvoriteHeartView(typeOfFavorite: nil, isFavorited: .constant(true))
                .previewLayout(.sizeThatFits)
            
            FarvoriteHeartView(typeOfFavorite: nil, isFavorited: .constant(true))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}


