//
//  CurrentlyPlayingFullScreen.swift
//  IndieMusic
//
//  Created by Kevin Green on 9/9/21.
//

import SwiftUI

struct CurrentlyPlayingFullScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: MainViewModel
    @EnvironmentObject var cpVM: CurrentlyPlayingViewModel
    
    var body: some View {
        ZStack {
            backgroundGradient
            
            dismissChevron
            
            VStack {
                Spacer()
                
                // Album artwork
                if !cpVM.showingLyrics {
                    albumArtwork
                } else {
                    showingLyricsView
                }
                
                // Song info
                if !cpVM.showingLyrics {
                    songInfo
                }
                
                // Track timeline
                trackTimeline
                
                // Play Control buttons
                playControlButtons
                
                Spacer()
                
                // volume control
                volumeControl

                // Option buttons
                optionButtons
                
                Spacer()
                
            }
        }
    }
}



extension CurrentlyPlayingFullScreen {
    
    private var dismissChevron: some View {
        VStack {
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.down")
                        .scaleEffect(1.3)
                        .foregroundColor(.white)
                        .opacity(0.8)
                }).padding()
                Spacer()
            }
            Spacer()
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(gradient: Gradient(colors: [Color(cpVM.dominantColors.1), Color(cpVM.dominantColors.0), Color.black]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            .opacity(0.7)
    }
    
    private var playControlButtons: some View {
        HStack {
            Button(action: {
                guard let user = vm.user else { return }
                cpVM.playPreviousSong(songList: user.songListData)
            }, label: {
                Image(systemName: "backward.fill")
                    .scaleEffect(2.3)
                    .padding(.leading, 40)
                    .foregroundColor(.white)
                    .opacity(0.7)
            })
            //                .disabled(cpVM.song.url.path != "")
            
            Spacer()
            
            Button(action: {
                cpVM.playPauseSong()
            }, label: {
                Image(systemName: cpVM.trackPlaying && !cpVM.trackEnded ? "pause.fill" : "play.fill")
                    .scaleEffect(4)
                    .foregroundColor(.white)
                    .opacity(0.7)
            })
            //                .disabled(cpVM.song.url.path != "")
            
            Spacer()
            
            Button(action: {
                guard let user = vm.user else { return }
                cpVM.playNextSong(songList: user.songListData)
            }, label: {
                Image(systemName: "forward.fill")
                    .scaleEffect(2.3)
                    .padding(.trailing, 40)
                    .foregroundColor(.white)
                    .opacity(0.7)
            })
            //                .disabled(cpVM.song.url.path != "")
            
        }.padding().padding(.top, 20)
    }
    
    private var volumeControl: some View {
        HStack {
            Image(systemName: "speaker.fill")
                .padding(.leading)
                .foregroundColor(.white)
                .opacity(0.8)
            
            VolumeSliderView()
                .frame(height: 40)
                .padding(.horizontal)
                .accentColor(.gray)
            
            Image(systemName: "speaker.wave.3.fill")
                .padding(.trailing)
                .foregroundColor(.white)
                .opacity(0.8)
        }
    }
    
    private var optionButtons: some View {
        HStack {
            Spacer()
            
            Button(action: {
                // Show lyrics
                withAnimation(Animation.easeOut) {
                    cpVM.showingLyrics.toggle()
                }
            }, label: {
                Image(systemName: "quote.bubble.fill")
                    .foregroundColor(!cpVM.song.hasLyrics ? .gray : .white)
                    .opacity(0.6)
                    .font(.system(size: 27))
            }).disabled(!cpVM.song.hasLyrics)
            
            Spacer()
            
            AirPlayButton().frame(width: 40, height: 40)
            
            Spacer()
            
            Menu(content: {
                Button("?????? - Hearts", action: self.doSomething)
                Button("?????? - Clubs", action: self.doSomething)
                Button("?????? - Spades", action: self.doSomething)
                Button("?????? - Diamonds", action: self.doSomething)
            }, label: {
                Image(systemName: "ellipsis.circle")
                    .foregroundColor(.white)
                    .opacity(0.6)
                    .font(.system(size: 27))
            })
            
            Spacer()
            
        }.padding([.horizontal, .top])
    }
        
    private var songInfo: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(cpVM.song.title)
                    .font(.title3)
                    .bold()
                    .foregroundColor(.white)
                    .opacity(0.7)
                
                Text(cpVM.album.artistName)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .opacity(0.5)
            }.padding(.leading)
            Spacer()
        }
        .transition(.scale)
    }
    
    private var trackTimeline: some View {
        VStack {
            ZStack(alignment: .leading) {
                Capsule().fill(Color.black.opacity(0.08)).frame(height: 5)
                Capsule().fill(Color.red).frame(width: cpVM.currentPlayTrackWidth, height: 5)

                // allows to scrub the track time by draging the progress bar
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                cpVM.currentPlayTrackWidth = value.location.x
                                cpVM.currTime = cpVM.audioPlayer.currentTime + 1
                                cpVM.remainingTime = cpVM.audioPlayer.currentTime - cpVM.audioPlayer.duration
                            })
                            .onEnded({ value in
                                let x = value.location.x
                                let screen = UIScreen.main.bounds.width - 30
                                let percent = x / screen
                                cpVM.audioPlayer.currentTime = Double(percent) * cpVM.audioPlayer.duration
                                cpVM.currTime = cpVM.audioPlayer.currentTime
                            })
                    )
            }.padding(.horizontal)
            
            
            HStack {
                Text(cpVM.currTime.timeFormat(unitsAllowed: cpVM.audioPlayer.duration >= 3600 ? [.hour, .minute, .second] : [.minute, .second]))
                    .font(.caption2)
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .opacity(0.7)
                
                Spacer()
                
                Text(cpVM.remainingTime.timeFormat(unitsAllowed: cpVM.audioPlayer.duration >= 3600 ? [.hour, .minute, .second] : [.minute, .second]))
                    .font(.caption2)
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .opacity(0.7)
            }.padding(.horizontal)
        }
    }
    
    private var showingLyricsView: some View {
        VStack {
            HStack {
                Image(uiImage: cpVM.albumImage)
                    .resizable()
                    .cornerRadius(4)
                    .frame(width: 40, height: 40, alignment: .leading)
                
                VStack(alignment: .leading) {
                    //                    MarqueTextView(text: song.title)
                    Text(cpVM.song.title)
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                        .opacity(0.7)
                    
                    //                    MarqueTextView(text: song.artistName)
                    Text(cpVM.album.artistName)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .opacity(0.5)
                }
                Spacer()
            }.padding(.leading)
            
            ScrollView {
                Text(cpVM.song.getLyrics())
                    .lineLimit(nil)
                    .font(.title2)
                    .padding(.horizontal)
                    .foregroundColor(.white)
                    .opacity(0.7)
            }.padding(.bottom)
            
            
        }
        .padding(.top, 40)
        .transition(.move(edge: .top))
    }
    
    private var albumArtwork: some View {
        Image(uiImage: cpVM.albumImage)
            .resizable()
            .cornerRadius(10)
            .aspectRatio(contentMode: .fit)
            .transition(.scale)
            .padding()
    }

    private func doSomething() {
        
    }

}






struct CurrentlyPlayingFullScreenView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CurrentlyPlayingFullScreen()
                .environmentObject(dev.mainVM)
                .environmentObject(dev.currentlyPlaingVM)
            
            CurrentlyPlayingFullScreen()
                .environmentObject(dev.mainVM)
                .environmentObject(dev.currentlyPlaingVM)
                .preferredColorScheme(.dark)
        }
    }
}
