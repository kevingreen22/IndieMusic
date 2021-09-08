//
//  SongsListView.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/8/21.
//

import SwiftUI

struct SongsListView: View {
    @Environment(\.defaultMinListRowHeight) var listRowHeight
    @EnvironmentObject var cpVM: CurrentlyPlayingViewModel
    @State private var selectedSongCell: Song?
    let songs: [Song]?
    let album: Album?
    
    var body: some View {
        if let _songs = songs {
            VStack {
                List {
                    ForEach(_songs, id: \.self) { song in
                        SongListCell(albumArtwork: cpVM.albumImage, song: song, selectedSongCell: $selectedSongCell)
                            .environmentObject(cpVM)
                    }
                }.environment(\.defaultMinListRowHeight, 60)
            }
        } else if let _album = album {
            VStack {
                Image(uiImage: cpVM.albumImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 230, height: 230)
                    .cornerRadius(8)
                    .shadow(radius: 25)
                
                Text(_album.title)
                    .font(.title2)
                    .bold()
                Text(_album.artistName)
                    .font(.title3)
                                
                List {
                    ForEach(_album.songs, id: \.self) { song in
                        SongListCell(albumArtwork: cpVM.albumImage, song: song, selectedSongCell: $selectedSongCell)
                            .environmentObject(cpVM)
                    }
                }.environment(\.defaultMinListRowHeight, 60)
            }
        }
    }
}



struct SongListCell: View {
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
                }
            }
    }
}







struct SongsListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SongsListView(songs: MockData.Songs(), album: nil)
                .environmentObject(ViewModel())
                .environmentObject(CurrentlyPlayingViewModel())
            SongsListView(songs: nil, album: MockData.Albums().first!)
                .environmentObject(ViewModel())
                .environmentObject(CurrentlyPlayingViewModel())
        }
    }
}
