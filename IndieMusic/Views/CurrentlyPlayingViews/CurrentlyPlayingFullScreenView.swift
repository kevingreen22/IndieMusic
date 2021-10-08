//
//  CurrentlyPlayingFullScreen.swift
//  IndieMusic
//
//  Created by Kevin Green on 9/9/21.
//

import SwiftUI

struct CurrentlyPlayingFullScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: ViewModel
    @EnvironmentObject var cpVM: CurrentlyPlayingViewModel
    
    var body: some View {
        ZStack {
            BackgroundGradient()
                .environmentObject(cpVM)
            
            DismissChevron()
            
            VStack {
                Spacer()
                
                // Album artwork
                if !cpVM.showingLyrics {
                    AlbumArtwork()
                } else {
                    ShowingLyricsView()
                        .environmentObject(cpVM)
                }
                
                // Song info
                if !cpVM.showingLyrics {
                    SongInfo()
                        .environmentObject(cpVM)
                }
                
                // Track timeline
                TrackTimeline()
                    .environmentObject(cpVM)
                
                // Play Control buttons
                PlayControlButtons()
                    .environmentObject(cpVM)
                
                Spacer()
                
                // volume control
                VolumeControl()

                // Option buttons
                OptionButtons()
                    .environmentObject(cpVM)
                
                Spacer()
                
            }
        }
    }
}




fileprivate struct DismissChevron: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
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
}

fileprivate struct BackgroundGradient: View {
    @EnvironmentObject var cpVM: CurrentlyPlayingViewModel
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(cpVM.dominantColors.1), Color(cpVM.dominantColors.0), Color.black]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            .opacity(0.7)
    }
}

fileprivate struct PlayControlButtons: View {
    @EnvironmentObject var vm: ViewModel
    @EnvironmentObject var cpVM: CurrentlyPlayingViewModel
    
    var body: some View {
        HStack {
            Button(action: {
                cpVM.playPreviousSong(songList: vm.user.songListData)
            }, label: {
                Image(systemName: "backward.fill")
                    .scaleEffect(2.3)
                    .padding(.leading, 40)
                    .foregroundColor(.white)
                    .opacity(0.7)
            }).disabled(cpVM.song.url.path != "")
            
            Spacer()
            
            Button(action: {
                cpVM.playPauseSong()
            }, label: {
                Image(systemName: cpVM.trackPlaying && !cpVM.trackEnded ? "pause.fill" : "play.fill")
                    .scaleEffect(4)
                    .foregroundColor(.white)
                    .opacity(0.7)
            }).disabled(cpVM.song.url.path != "")
            
            Spacer()
            
            Button(action: {
                cpVM.playNextSong(songList: vm.user.songListData)
            }, label: {
                Image(systemName: "forward.fill")
                    .scaleEffect(2.3)
                    .padding(.trailing, 40)
                    .foregroundColor(.white)
                    .opacity(0.7)
            }).disabled(cpVM.song.url.path != "")
            
        }.padding().padding(.top, 20)
    }
}

fileprivate struct VolumeControl: View {
    var body: some View {
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
}

fileprivate struct OptionButtons: View {
    @EnvironmentObject var cpVM: CurrentlyPlayingViewModel
    
    var body: some View {
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
                Button("♥️ - Hearts", action: doSomething)
                Button("♣️ - Clubs", action: doSomething)
                Button("♠️ - Spades", action: doSomething)
                Button("♦️ - Diamonds", action: doSomething)
            }, label: {
                Image(systemName: "ellipsis.circle")
                    .foregroundColor(.white)
                    .opacity(0.6)
                    .font(.system(size: 27))
            })
            
            Spacer()
            
        }.padding([.horizontal, .top])
    }
    
    private func doSomething() {
        
    }
    
}

fileprivate struct SongInfo: View {
    @EnvironmentObject var cpVM: CurrentlyPlayingViewModel
    
    var body: some View {
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
}

fileprivate struct TrackTimeline: View {
    @EnvironmentObject var cpVM: CurrentlyPlayingViewModel
    
    var body: some View {
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

fileprivate struct ShowingLyricsView: View {
    @EnvironmentObject var cpVM: CurrentlyPlayingViewModel
    
    var body: some View {
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
}


fileprivate struct AlbumArtwork: View {
    @EnvironmentObject var cpVM: CurrentlyPlayingViewModel
    
    var body: some View {
        Image(uiImage: cpVM.albumImage)
            .resizable()
            .cornerRadius(10)
            .aspectRatio(contentMode: .fit)
            .transition(.scale)
            .padding()
    }
}








struct CurrentlyPlayingFullScreenView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentlyPlayingFullScreen()
            .environmentObject(ViewModel())
            .environmentObject(CurrentlyPlayingViewModel())
    }
}
