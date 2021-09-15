//
//  CurrentlyPlayingMinimizedView.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/16/21.
//

import SwiftUI
import AVKit

struct CurrentlyPlayingMinimizedView: View {
    @EnvironmentObject var vm: ViewModel
    @EnvironmentObject var cpVM: CurrentlyPlayingViewModel
    
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                Capsule().fill(Color.black.opacity(0.08)).frame(height: 3)
                Capsule().fill(Color.red).frame(width: cpVM.currentPlayTrackWidth, height: 3)
            }
            
            HStack {
                Image(uiImage: cpVM.albumImage)
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .leading)
                    .cornerRadius(5)
                
//                MarqueTextView(text: song.title)
                Text(cpVM.song.title)
                    .truncationMode(.tail)
                
                Spacer()
                Spacer()
                
                Button(action: {
                    cpVM.playPauseSong()
                }, label: {
                    Image(systemName: cpVM.trackPlaying ? "pause.fill" : "play.fill")
                        .foregroundColor(.black)
                        .scaleEffect(1.4)
                })
                
                Spacer()
                
                Button(action: {
                    cpVM.playNextSong(user: vm.user)
                }, label: {
                    Image(systemName: "forward.fill")
                        .foregroundColor(.black)
                        .scaleEffect(1.4)
                }).padding(.trailing)
                
            }
            .padding(.horizontal)
            .offset(y: -5)
            
        }
        .frame(height: ViewModel.Constants.currentlyPlayingMinimizedViewHeight)
        .background(Color.gray)
        
        .onTapGesture {
            // Show currently playing song full screen view
            cpVM.showFullScreenCover.toggle()
        }
        
        .fullScreenCover(isPresented: $cpVM.showFullScreenCover, content: {
            CurrentlyPlayingFullScreen(album: cpVM.album, song: cpVM.song)
                .environmentObject(cpVM)
        })
        
        .onAppear {
            cpVM.initSongAlbum(user: vm.user)
        }
    }
}






struct CurrentlyPlayingView_Previews: PreviewProvider {
    static var previews: some View {
        let album = MockData.Albums().first!
        let song = MockData.Songs().first!
        
        Group {
            CurrentlyPlayingMinimizedView()
                .environmentObject(CurrentlyPlayingViewModel())                
        }
    }
}


