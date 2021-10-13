//
//  SongsListView.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/8/21.
//

import SwiftUI

struct SongsListView: View {
    @Environment(\.defaultMinListRowHeight) var listRowHeight
    @EnvironmentObject var vm: MainViewModel
    @EnvironmentObject var cpVM: CurrentlyPlayingViewModel
    let songs: [Song]?
    let album: Album?
    
    var body: some View {
        if let _songs = songs {
            VStack {
                List {
                    ForEach(_songs, id: \.self) { song in
                        SongListCell(song: song, selectedSongCell: $vm.selectedSongCell)
                            .environmentObject(vm)
                            .environmentObject(cpVM)
                    }
                }.environment(\.defaultMinListRowHeight, 60)
            }.navigationBarTitle("Songs", displayMode: .large)
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
                    .foregroundColor(.gray)
                                
                List {
                    ForEach(_album.songs, id: \.self) { song in
                        SongListCell(song: song, selectedSongCell: $vm.selectedSongCell)
                            .environmentObject(vm)
                            .environmentObject(cpVM)
                    }
                }.environment(\.defaultMinListRowHeight, 60)
            }
            
        }
    }
}




struct SongsListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SongsListView(songs: MockData.Songs(), album: nil)
                .environmentObject(MainViewModel())
                .environmentObject(CurrentlyPlayingViewModel())
            
            SongsListView(songs: nil, album: MockData.Albums().first!)
                .environmentObject(MainViewModel())
                .environmentObject(CurrentlyPlayingViewModel())
        }
    }
}
