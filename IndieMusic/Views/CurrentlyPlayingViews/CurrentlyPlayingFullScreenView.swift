//
//  CurrentlyPlayingFullScreen.swift
//  IndieMusic
//
//  Created by Kevin Green on 9/9/21.
//

import SwiftUI

struct CurrentlyPlayingFullScreen: View {
    let album: Album
    let song: Song
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var cpVM: CurrentlyPlayingViewModel
    

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(cpVM.dominantColors.1), Color(cpVM.dominantColors.0), Color.black]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                .opacity(0.7)
            
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
            
            VStack {
                // Album artwork
                if !cpVM.showingLyrics {
                    Image(uiImage: cpVM.albumImage)
                        .resizable()
                        .cornerRadius(10)
                        .aspectRatio(contentMode: .fit)
                        .transition(.scale)
                        .padding()
                    
                } else {
                    VStack {
                        HStack {
                            Image(uiImage: cpVM.albumImage)
                                .resizable()
                                .cornerRadius(4)
                                .frame(width: 40, height: 40, alignment: .leading)
                            
                            VStack(alignment: .leading) {
//                                MarqueTextView(text: song.title)
                                Text(song.title)
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.white)
                                    .opacity(0.7)
                                
//                                MarqueTextView(text: song.artistName)
                                Text(album.artistName)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .opacity(0.7)
                            }
                            Spacer()
                        }.padding(.leading)
                        
                        ScrollView {
                            Text(song.getLyrics())
                                .lineLimit(nil)
                                .font(.title2)
                                .padding(.horizontal)
                                .foregroundColor(.white)
                                .opacity(0.7)
                        }.frame(height: 300)
                            
                        
                    }
                    .padding(.top, 40)
                    .transition(.move(edge: .top))
                }
                
                
                // Song info
                HStack {
                    VStack(alignment: .leading) {
                        Text(song.title)
                            .font(.title3)
                            .bold()
                            .foregroundColor(.white)
                            .opacity(0.7)
                        
                        Text(album.artistName)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .opacity(0.7)
                        
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
                        }
                        
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
                        }
                        
                    }.padding(.horizontal)
                    Spacer()
                }
                
                
                // Control buttons
                HStack {
                    Button(action: {
                        cpVM.playPreviousSong()
                    }, label: {
                        Image(systemName: "backward.fill")
                            .scaleEffect(2.3)
                            .padding(.leading, 40)
                            .foregroundColor(.white)
                            .opacity(0.7)
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        cpVM.playPauseSong()
                    }, label: {
                        Image(systemName: cpVM.trackPlaying && !cpVM.trackEnded ? "pause.fill" : "play.fill")
                            .scaleEffect(4)
                            .foregroundColor(.white)
                            .opacity(0.7)
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        cpVM.playNextSong()
                    }, label: {
                        Image(systemName: "forward.fill")
                            .scaleEffect(2.3)
                            .padding(.trailing, 40)
                            .foregroundColor(.white)
                            .opacity(0.7)
                    })
                    
                }.padding().padding(.top, 20)
                
                Spacer()
                
                // volume control
                HStack {
                    Image(systemName: "speaker.fill")
                        .padding(.leading)
                        .scaleEffect(0.8)
                        .foregroundColor(.white)
                        .opacity(0.8)
                    
                    VolumeSliderView()
                        .frame(height: 40)
                        .padding(.horizontal)
                        .accentColor(.gray)
                    
                    Image(systemName: "speaker.wave.3.fill")
                        .padding(.trailing)
                        .scaleEffect(0.8)
                        .foregroundColor(.white)
                        .opacity(0.8)
                }
                
                
                // option buttons
                HStack {
                    Spacer()
                    
                    Button(action: {
                        // Show lyrics
                        withAnimation(Animation.easeOut) {
                            cpVM.showingLyrics.toggle()
                        }
                    }, label: {
                        Image(systemName: "quote.bubble.fill")
                            .foregroundColor(.white)
                            .opacity(0.6)
                    }).disabled(!song.hasLyrics)
                    
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
                    })

                    Spacer()
                    
                }.padding([.horizontal, .top])
                
                Spacer()
                
            }
        }
    }
    
    private func doSomething() {
        
    }
    
}




struct CurrentlyPlayingFullScreenView_Previews: PreviewProvider {
    static var previews: some View {
        let album = MockData.Albums().first!
        let song = MockData.Songs().first!
        
        CurrentlyPlayingFullScreen(album: album, song: song)
            .environmentObject(CurrentlyPlayingViewModel())
    }
}
