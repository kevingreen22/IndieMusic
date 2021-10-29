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
            trackTimeLine
            Spacer()
            HStack {
                albumArtworkImage
                titleTexts
                Spacer()
                Spacer()
                playButton
                Spacer()
                forwardButton
            }
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
        
        .fullScreenCover(isPresented: $cpVM.showFullScreenCover) {
            CurrentlyPlayingFullScreen()
                .environmentObject(vm)
                .environmentObject(cpVM)
        }
        
    }
}


extension CurrentlyPlayingMinimizedView {
    
    private var trackTimeLine: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .fill(Color.black.opacity(0.08))
                .frame(height: 3)
            Capsule()
                .fill(Color.theme.primary)
                .frame(width: cpVM.currentPlayTrackWidth, height: 3)
        }
    }
    
    private var albumArtworkImage: some View {
        Image(uiImage: cpVM.albumImage)
            .resizable()
            .frame(width: 50, height: 50, alignment: .leading)
            .foregroundColor(Color.theme.primaryText)
            .cornerRadius(5)
            .padding(.leading)
    }
    
    private var titleTexts: some View {
        VStack {
            Text(cpVM.song.title)
                .truncationMode(.tail)
            Text(cpVM.song.artistName)
                .truncationMode(.tail)
                .foregroundColor(Color.gray)
                .opacity(0.70)
        }
    }
    
    private var playButton: some View {
        Button(action: {
            cpVM.playPauseSong()
        }, label: {
            Image(systemName: cpVM.trackPlaying && !cpVM.trackEnded ? "pause.fill" : "play.fill")
                .foregroundColor(Color.theme.primaryText)
                .scaleEffect(1.4)
        })//.disabled(cpVM.song.url.path != "")
        
    }
    
    private var forwardButton: some View {
        Button(action: {
            guard let user = vm.user else { return }
            cpVM.playNextSong(songList: user.songListData)
        }, label: {
            Image(systemName: "forward.fill")
                .foregroundColor(Color.theme.primaryText)
                .scaleEffect(1.4)
        })
        .padding(.trailing)
//        .disabled(cpVM.song.url.path != "")
        
    }
    
}




struct CurrentlyPlayingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CurrentlyPlayingMinimizedView()
                .environmentObject(dev.mainVM)
                .environmentObject(dev.currentlyPlaingVM)
                .previewLayout(.sizeThatFits)
            
            CurrentlyPlayingMinimizedView()
                .environmentObject(dev.mainVM)
                .environmentObject(dev.currentlyPlaingVM)
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}


