//
//  CurrentlyPlayingMinimizedView.swift
//  IndieMusic
//
//  Created by Kevin Green on 7/16/21.
//

import SwiftUI
import AVKit

struct CurrentlyPlayingMinimizedView: View {
    @EnvironmentObject var vm: MainViewModel
    @EnvironmentObject var cpVM: CurrentlyPlayingViewModel
    
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.black.opacity(0.08))
                    .frame(height: 3)
                Capsule()
                    .fill(Color.theme.primary)
                    .frame(width: cpVM.currentPlayTrackWidth, height: 3)
            }
            Spacer()
            HStack {
                Image(uiImage: cpVM.albumImage)
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .leading)
                    .cornerRadius(5)
                    .padding(.leading)
                
                VStack {
                    Text(cpVM.song.title).truncationMode(.tail)
                    Text(cpVM.song.artistName).truncationMode(.tail)
                }
                
                Spacer()
                Spacer()
                
                Button(action: {
                    cpVM.playPauseSong()
                }, label: {
                    Image(systemName: cpVM.trackPlaying && !cpVM.trackEnded ? "pause.fill" : "play.fill")
                        .foregroundColor(.black)
                        .scaleEffect(1.4)
                }).disabled(cpVM.song.url.path != "")
                
                Spacer()
                
                Button(action: {
                    guard let user = vm.user else { return }
                    cpVM.playNextSong(songList: user.songListData)
                }, label: {
                    Image(systemName: "forward.fill")
                        .foregroundColor(.black)
                        .scaleEffect(1.4)
                })
                .padding(.trailing)
                .disabled(cpVM.song.url.path != "")
                
            }
            .padding(.horizontal)
            .offset(y: -9)
            
        }
        .background(RealBlurView())
        .frame(height: MainViewModel.Constants.currentlyPlayingMinimizedViewHeight)
        .background(Color.theme.tabBarBackground.opacity(0.7))
        .clipShape(Capsule())
        .padding(.horizontal)
        
        
        .onTapGesture {
            // Show currently playing song full screen view
            cpVM.showFullScreenCover.toggle()
        }
        
        .fullScreenCover(isPresented: $cpVM.showFullScreenCover, content: {
            CurrentlyPlayingFullScreen()
                .environmentObject(vm)
                .environmentObject(cpVM)
        })
        
    }
}






struct CurrentlyPlayingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CurrentlyPlayingMinimizedView()
                .environmentObject(dev.currentlyPlaingVM)
            
            CurrentlyPlayingMinimizedView()
                .environmentObject(dev.currentlyPlaingVM)
                .preferredColorScheme(.dark)
        }
    }
}


