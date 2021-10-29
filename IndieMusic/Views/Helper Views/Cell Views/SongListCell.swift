//
//  SongListCell.swift
//  IndieMusic
//
//  Created by Kevin Green on 10/21/21.
//

import SwiftUI

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
                                Color.black.opacity(0.3)
                                SwimplyPlayIndicator(state: $cpVM.playState, color: Color.theme.primary, style: .legacy)
                                    .frame(width: constants.playIndicatorSize, height: constants.playIndicatorSize, alignment: .leading)
                            }
                        }
                        .cornerRadius(3)
                    )
                
//                if cpVM.audioPlayer.isPlaying {
//                    SwimplyPlayIndicator(state: $cpVM.playState, style: .modern)
//                        .frame(width: constants.playIndicatorSize, height: constants.playIndicatorSize, alignment: .leading)
//                }
                
                Text(song.title)
                    .font(.title)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                Spacer()
                
                FarvoriteHeartView(typeOfFavorite: Song.self, isFavorited: $isFavorited).padding(.trailing, 5)
            }
            .gesture(cellTapped)
        }
    }
}


extension SongListCell {
    
    var cellTapped: some Gesture {
        TapGesture()
            .onEnded {
                selectedSongCell = song
                cpVM.song = song
                if let user = vm.user {
                    user.addSongToUserSongList(song: song)
                    vm.updateUser()
                }
            }
    }
    
}


struct SongListCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SongListCell(song: dev.songs.first!, selectedSongCell: .constant(dev.songs.first!))
                .environmentObject(dev.mainVM)
                .environmentObject(dev.currentlyPlaingVM)
                .previewLayout(.sizeThatFits)
            
            SongListCell(song: dev.songs.first!, selectedSongCell: .constant(dev.songs.first!))
                .environmentObject(dev.mainVM)
                .environmentObject(dev.currentlyPlaingVM)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
